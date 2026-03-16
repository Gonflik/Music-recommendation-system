from flask import Blueprint, jsonify, request
from app.model import Artist, Album, Song, Playlist
from flask_jwt_extended import jwt_required

search_bp = Blueprint('search', __name__)

@search_bp.get('/search')
@jwt_required()
def search():
    query = request.args.get('q', default='', type=str).strip()
    clean_query = query.replace('"', '').replace("'", "").strip()
    if not clean_query:
        return jsonify({"message": "Query term is not provided or is invalid!"}), 400
    
    artists = Artist.search_for_artist_by_query(query)
    if not artists:
        return jsonify({"error":"Artist not found!"}), 404
    
    raw_result = {
        "Artists": [artist.to_dict() for artist in artists],
        #"Songs": Song.search_for_song_by_query(query),
        #"Albums": Album.search_for_album_by_query(query),
        #"Playlists": Playlist.search_for_playlist_by_query(query),
    }
    
    """final_result = {}
    for key, items in raw_result.items():
        if items:
            final_result[key] = [item.to_dict() for item in items]"""

    return jsonify(raw_result)

