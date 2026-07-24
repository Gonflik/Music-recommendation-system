from flask import Blueprint, jsonify, request, url_for, render_template
from app.model import Artist, Album, Song, ToListen
from flask_jwt_extended import jwt_required, current_user
from app.extensions import redis_client
import json

search_bp = Blueprint('search', __name__)


@search_bp.get('/search')
def search_page():
    return render_template("search.html")

@search_bp.get('/api/search')
@jwt_required()
def search():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    query = request.args.get('q', default='', type=str).strip()
    clean_query = query.replace('"', '').replace("'", "").strip()
    if not clean_query:
        return jsonify({"message": "Query term is not provided or is invalid!"}), 400

    SEARCH_TTL = 5 * 60
    cache_key = f"search:{query}:{page}:{per_page}"

    cached = redis_client.get(cache_key)
    if cached:
        cached_result = json.loads(cached)
        artists = cached_result["Artists"]
        songs = cached_result["Songs"]
        albums = cached_result["Albums"]
    else:
        artists = Artist.search_for_artist_by_query(query, per_page=per_page, page=page)
        songs = Song.search_for_song_by_query(query, per_page=per_page, page=page)
        albums = Album.search_for_album_by_query(query, per_page=per_page, page=page)
        if not artists and not songs and not albums:
            return jsonify({"error": "Not found!"}), 404

        artists = [artist.to_dict() for artist in artists] if artists else artists
        songs = [song.to_dict() for song in songs] if songs else songs
        albums = [album.to_dict() for album in albums] if albums else albums
        
        redis_client.set(cache_key, json.dumps(
                {"Artists": artists,
                 "Songs": songs,
                 "Albums": albums}),
                 ex=SEARCH_TTL)
    
    
    for album in albums:
        album["in_tolisten"] = ToListen.exists_for_user(current_user.id, album["id"])

    raw_result = {
        "Artists": artists,
        "Songs": songs,
        "Albums": albums,
        "links": {
            "next_page": url_for('search.search',q=query ,page = page + 1, per_page = per_page),
            "prev_page": url_for('search.search',q=query, page = (page - 1) if page - 1 != 0 else page, per_page=per_page)
        }
    }
    
    return jsonify(raw_result)

