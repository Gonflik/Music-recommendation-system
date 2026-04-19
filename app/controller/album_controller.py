from flask import Blueprint, jsonify, request, url_for
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action
from app.model.action import ActionName, ReferenceClassName

album_bp = Blueprint('artist', __name__)

@album_bp.get('/albums')
@jwt_required()
def album_index():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    #Album.get

@album_bp.get('/albums/<int:album_id>')
@jwt_required()
def album_show(album_id):
    album = Album.get_album_by_id(album_id, load_songs=True)
    if not album:
        return jsonify({"error": "Album not found!"}), 404
    
    Action.create_or_increment(name=ActionName.ALBUM_SHOW ,user_id=current_user.id, reference_id=album.id, reference_name=ReferenceClassName.ALBUM)

    album_dict = album.to_dict()    
    album_dict["Songs"] = sorted([s.to_dict() for s in album.songs], key=lambda song: song.get("song_position"))

    return jsonify({"Album": album_dict})
