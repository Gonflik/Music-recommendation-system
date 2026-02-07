from flask import Blueprint, jsonify, request
from app.model.tolisten import ToListen

tolisten_bp = Blueprint('tolisten', __name__)

@tolisten_bp.get('/<int:id>/tolisten')
def tolisten_get_by_user_id(id):
    entries = ToListen.get_album_join_tolisten_by_user_id(id)
    results = []
    for entry in entries:
        results.append({
            "id": entry.id,
            "note": entry.note,
            "album": {
                "id": entry.album.id,
                "name": entry.album.name,
                "length": entry.album.length,
                "avg_rating": entry.album.avg_rating or 0,
                "artist_name": entry.album.artist.name
            }
        })
    return jsonify(results)

    

    