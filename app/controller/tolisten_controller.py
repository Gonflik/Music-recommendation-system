from flask import Blueprint, jsonify, request, render_template
from app.model import ToListen, Album, User, Action
from app.model.action import ActionName, ReferenceClassName
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity


tolisten_bp = Blueprint('tolisten', __name__)

@tolisten_bp.get('/tolisten')
def tolisten_page():
    return render_template("tolisten.html")

@tolisten_bp.get('/api/tolisten')
@jwt_required()
def tolisten_get_by_user_id():
    user_id = current_user.id
    entries = ToListen.get_all_join_album_join_artist_by_user_id(user_id)
    results = []
    total_length = 0
    for entry in entries:
        results.append({
            "id": entry.id,
            "note": entry.note,
            "listened": entry.listened,
            "created_at": entry.created_at,
            "Album": entry.album.to_dict()
        })
        total_length += entry.album.length
    return jsonify({"ToListen": sorted(results, key=lambda x: x.get("created_at")),
                    "Total ToListen length": f"{total_length/60} sec"
    })

@tolisten_bp.post('/api/tolisten')
@jwt_required()
def tolisten_add_album_to_user():
    data = request.get_json()
    
    note = data.get('note', '')
    album_id = data.get('album_id')

    album = Album.get_album_by_id(album_id)
    
    if not album:
        return jsonify({"message": "Album not found!"}), 404
    
    if ToListen.exists_for_user(current_user.id, album_id):
            return jsonify({"error": "Yo already have this album in tolisten!"}), 409
    
    tolisten_entry = ToListen(note=note, user_id=current_user.id, album_id=album_id)
    tolisten_entry.save()
    

    Action.create_or_increment(name=ActionName.ADD_TO_LISTEN ,user_id=current_user.id, reference_id=album_id, reference_name=ReferenceClassName.ALBUM)

    return jsonify({"message": "Album succesfully added!", "tolisten_id": tolisten_entry.id}), 201
    
@tolisten_bp.delete('/api/tolisten/<int:tolisten_id>')
@jwt_required()
def tolisten_delete_album(tolisten_id):
    entry = ToListen.get_one_tolisten_by_id(tolisten_id)
    if entry.user_id != current_user.id:
        return jsonify({"message": "You are not authorized to access this!"}), 403
    if entry:
        entry.delete()
        return jsonify({"message": "ToListen entry deleted successfully!"}), 200
    return jsonify({"message": "No ToListen entry with such id!"}), 404
    

@tolisten_bp.patch('/api/tolisten/<int:tolisten_id>')
@jwt_required()
def tolisten_update_note(tolisten_id):
    data = request.get_json()
    
    entry = ToListen.get_one_tolisten_by_id(tolisten_id)
    
    if not entry:
        return jsonify({"message": "No ToListen entry with such id!"}), 404
    
    if entry.user_id != current_user.id:
        return jsonify({"message": "You are not authorized to access this!"}), 403
    
    note = data.get('note')
    if "note" in data:  
        entry.note = note
    listened = data.get('listened')
    if "listened" in data:
        entry.listened = listened
    entry.save()
    return jsonify({"message": "Note updated successfully!"}), 200
    
