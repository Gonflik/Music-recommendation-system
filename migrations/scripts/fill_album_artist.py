import deezer
import time
from app import db, create_app
from app.model import Artist, Album
from sqlalchemy import select
from dotenv import load_dotenv

load_dotenv()

app = create_app()

with app.app_context():
    albums = db.session.scalars(select(Album)).all()
    with deezer.Client() as client:
        i = 0
        for alb in albums:
            i += 1
            found_album = client.get_album(alb.dzid)
            alb.release_date = found_album.release_date
            alb.release_type = found_album.record_type
            print(f"Album item {i} proccesing")
            time.sleep(0.5)
            print(f"Success(probably)")

    artists = db.session.scalars(select(Artist)).all()
    with deezer.Client() as client:
        y = 0
        for art in artists:
            y += 1
            found_artist = client.get_artist(art.dzid)
            art.ghost_albums_count = found_artist.nb_album
            print(f"Artist item {i} proccesing")
            time.sleep(0.5)
            print(f"Success(probably)")

    db.session.commit()