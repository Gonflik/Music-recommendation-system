"""
update_pictures.py

Updates `picture` column on Album, Artist, and Song to Deezer's picture_big / picture_xl.
Rate-limited to 50 req/min (1.2s sleep between calls).

Usage:
    python update_pictures.py
    python update_pictures.py --dry-run
    python update_pictures.py --model album
    python update_pictures.py --model artist
    python update_pictures.py --model song
"""

import time
import argparse
import deezer
from app import create_app, db
from app.model import Album, Artist, Song  # adjust import path

RATE_LIMIT_SLEEP = 0.7  # 50 req/min = 1.2s between calls


def fetch_picture_big(client, model_name: str, deezer_id: int) -> str | None:
    try:
        if model_name == "album":
            obj = client.get_album(deezer_id)
            return obj.cover_xl
        elif model_name == "artist":
            obj = client.get_artist(deezer_id)
            return obj.picture_xl  # deezer-python: picture_xl for artists
        elif model_name == "song":
            obj = client.get_track(deezer_id)
            return obj.album.cover_xl  # track → album cover
    except Exception as e:
        print(f"  [WARN] Deezer error for {model_name} id={deezer_id}: {e}")
        return None


from sqlalchemy import select

def update_model(client, model_cls, model_name: str, picture_attr: str, dry_run: bool):
    total = db.session.execute(
        select(model_cls).filter(model_cls.dzid.isnot(None))
    ).scalars().all()

    print(f"\n{'='*50}")
    print(f"{model_name.upper()}: {len(total)} records with deezer_id")
    print(f"{'='*50}")

    updated = skipped = failed = 0

    for record in total:
        print(f"  [{model_name}] id={record.id} dzid={record.dzid}", end=" ... ")

        picture_big = fetch_picture_big(client, model_name, record.dzid)
        time.sleep(RATE_LIMIT_SLEEP)

        if not picture_big:
            print("FAILED (no picture returned)")
            failed += 1
            continue

        current = getattr(record, picture_attr)
        if picture_big == current:
            print("SKIP (already up to date)")
            skipped += 1
            continue

        if dry_run:
            print(f"DRY-RUN → {picture_big}")
            updated += 1
            continue

        setattr(record, picture_attr, picture_big)
        updated += 1
        print(f"OK → {picture_big}")

    if not dry_run:
        db.session.commit()

    print(f"\n{model_name.upper()} done: {updated} updated, {skipped} skipped, {failed} failed")
    return updated, skipped, failed


def main():
    parser = argparse.ArgumentParser(description="Update pictures from Deezer")
    parser.add_argument("--dry-run", action="store_true", help="Print changes without writing to DB")
    parser.add_argument("--model", choices=["album", "artist", "song", "all"], default="all")
    args = parser.parse_args()

    app = create_app()
    client = deezer.Client()

    # (model_cls, model_name, picture_attr)
    models = [
        (Album,  "album",  "picture"),
        (Artist, "artist", "picture"),
        (Song,   "song",   "picture"),
    ]

    with app.app_context():
        for model_cls, model_name, picture_attr in models:
            if args.model in (model_name, "all"):
                update_model(client, model_cls, model_name, picture_attr, args.dry_run)

    print("\nAll done.")


if __name__ == "__main__":
    main()