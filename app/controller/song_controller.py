from flask import Blueprint, jsonify, request, url_for
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist
from app.extensions import redis_client

song_bp = Blueprint('song', '__name__')


@song_bp.get('/api/songs/top-rated')
def song_toprated():
    songs = Song.get_top_songs(limit=4)
    if not songs:
        return jsonify({"message": "Top songs not found!"}), 404
    
    return jsonify({"top_songs": [i.to_dict() for i in songs]})


@song_bp.get('/api/songs/<int:song_id>/preview')
@jwt_required()
def song_preview(song_id):
    PREVIEW_TTL = 60 * 60
    cache_key = f"preview:{song_id}"

    cached = redis_client.get(cache_key)
    if cached:
        return jsonify({"preview_url": cached.decode()})

    song = Song.get_song_by_id(song_id)
    if not song:
        return jsonify({"error": "Song not found!"}), 404

    try:
        import deezer
        client = deezer.Client()
        track = client.get_track(song.dzid)
        preview_url = track.preview
    except Exception as e:
        return jsonify({"error": "Could not fetch preview"}), 502
    
    if not preview_url:
        return jsonify({"error": "No preview available"}), 404
    
    redis_client.set(cache_key, preview_url, ex=PREVIEW_TTL)
    return jsonify({"preview_url": preview_url})