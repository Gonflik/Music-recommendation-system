from flask import Blueprint, jsonify, request, render_template
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action, ToListen
from app.model.action import ActionName, ReferenceClassName
from app.extensions import redis_client
import json

artist_bp = Blueprint('artist', __name__)


@artist_bp.get('/artists/<int:artist_id>')
def artist_show_page(artist_id):
    return render_template("artist_show.html", artist_id=artist_id)

@artist_bp.get('/api/artists/<int:artist_id>')
@jwt_required()
def artist_show(artist_id):
    limit = request.args.get("limit", default=None, type=int)
    artist = Artist.get_artist_by_id(artist_id)
    if not artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    Action.create_or_increment(name=ActionName.ARTIST_SHOW, user_id=current_user.id, reference_id=artist.id, reference_name=ReferenceClassName.ARTIST)

    cache_key = f"artist:{artist_id}:{limit}"
    ARTIST_TTL = 10 * 60

    cached = redis_client.get(cache_key)
    if cached:
        cached_result = json.loads(cached)
        top_songs = cached_result["Top_songs"]
        all_top = cached_result["total_top_songs"]
        all_albums = cached_result["Albums"]
    else:
        top_songs, all_top = artist.get_top_songs_deezer(limit=limit)
        all_albums = artist.get_all_albums_deezer()
    
        top_songs = [i.to_dict() for i in top_songs] if top_songs else []
        all_albums = [i.to_dict() for  i in all_albums] if all_albums else []

        redis_client.set(cache_key, json.dumps(
                        {"Top_songs": top_songs,
                         "total_top_songs": all_top,
                         "Albums": all_albums}), ex=ARTIST_TTL)

    for album in all_albums:
        album["in_tolisten"] = ToListen.exists_for_user(current_user.id, album["id"])


    return jsonify({
        "Artist": artist.to_dict(),
        "Top_songs": top_songs,
        "total_top_songs": all_top,
        "Albums": all_albums,
    }), 200




