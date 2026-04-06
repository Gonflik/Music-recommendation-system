from flask import Blueprint, jsonify, request, url_for
from app.model import Artist, Album, Song
from flask_jwt_extended import jwt_required

search_bp = Blueprint('search', __name__)

@search_bp.get('/search')
@jwt_required()
def search():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    query = request.args.get('q', default='', type=str).strip()
    clean_query = query.replace('"', '').replace("'", "").strip()
    if not clean_query:
        return jsonify({"message": "Query term is not provided or is invalid!"}), 400
    
    artists = Artist.search_for_artist_by_query(query, per_page=per_page, page=page)
    songs = Song.search_for_song_by_query(query, per_page=per_page, page=page)
    albums = Album.search_for_album_by_query(query, per_page=per_page, page=page)
    if not artists and not songs and not albums:
        return jsonify({"error": "Not found!"}), 404
    
    raw_result = {
        "Artists": [artist.to_dict() for artist in artists] if artists else artists,
        "Songs": [song.to_dict() for song in songs] if songs else songs,
        "Albums": [album.to_dict() for album in albums] if albums else albums,
        "links": {
            "next_page": url_for('search.search',q=query ,page = page + 1, per_page = per_page),
            "prev_page": url_for('search.search',q=query, page = (page - 1) if page - 1 != 0 else page, per_page=per_page)
        }
    }
    
    return jsonify(raw_result)

