from flask import Blueprint, jsonify, request
from app.model import Artist, Album, Song, Playlist

search_bp = Blueprint('search', __name__)

@search_bp.get('/search')
def search():
    query = request.args.get('q', default='', type=str).strip()

    if not query:
        return   jsonify({"message": "Query term is not provided!"}), 400

    raw_result = {
        "Artists": Artist.search_for_artist_by_query(query),
        "Songs": Song.search_for_song_by_query(query),
        "Albums": Album.search_for_album_by_query(query),
        "Playlists": Playlist.search_for_playlist_by_query(query),
    }

    final_result = {}
    for key, items in raw_result.items():
        if items:
            final_result[key] = [item.to_dict() for item in items]

    return jsonify(final_result)

