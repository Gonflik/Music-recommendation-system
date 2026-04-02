from flask import Blueprint, jsonify, request
from app.model import Artist, Album, Song
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
    songs = Song.search_for_song_by_query(query)
    albums = Album.search_for_album_by_query(query)
    
    
    raw_result = {
        "Artists": [artist.to_dict() for artist in artists] if artists else artists,
        "Songs": [song.to_dict() for song in songs] if songs else songs,
        "Albums": [album.to_dict() for album in albums] if albums else albums
    }
    
    return jsonify(raw_result)

