from flask import Blueprint, jsonify, request
from app.model import ToListen, Album, User

tolisten_bp = Blueprint('tolisten', __name__)

@tolisten_bp.get('/tolisten/<int:user_id>')
def tolisten_get_by_user_id(user_id):
    entries = ToListen.get_album_join_tolisten_join_artist_by_user_id(user_id)
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

@tolisten_bp.post('/tolisten/<int:user_id>')
def tolisten_add_album_to_user(user_id):
    data = request.get_json()
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    note = data.get('note', '')
    album_id = data.get('album_id')
    album_name = data.get('album_name')
    album = None

    if album_id:
        album = Album.get_album_by_id(album_id)
    elif album_name:
        album = Album.get_album_by_name(album_name)
    
    if not album:
        return jsonify({"message": "Album not found!"}), 404
    
    tolisten_entry = ToListen(note=note, user_id=user_id, album_id=album.id)
    tolisten_entry.save()
    return jsonify({"message": "Album succesfully added!"}), 201
    
    """if album_id:
        album = Album.get_album_by_id(album_id)
        if album:
            tolisten_entry = ToListen(note=note, user_id=user_id, album_id=album_id)
            tolisten_entry.save()
            return jsonify({"message": "Album succesfully added!"}), 201
        return jsonify({"message": "Album not found!"})
    
    album_name = data.get('album_name')
    if album_name:
        album = Album.get_album_by_name(album_name)
        if album:
            tolisten_entry = ToListen(note=note, user_id=user_id, album_id=album.id)
        return jsonify({"message": "Album not found!"})"""
@tolisten_bp.delete('/toliste/<int:user_id>')
def tolisten_delete_album(user_id):
    pass
