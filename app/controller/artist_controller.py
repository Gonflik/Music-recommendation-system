from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action
from app.model.action import ActionName, ReferenceClassName

artist_bp = Blueprint('artist', __name__)

@artist_bp.get('/artists')
@jwt_required()
def artist_index():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    
@artist_bp.get('/artists/<int:artist_id>')
@jwt_required()
def artist_show(artist_id):
    artist = Artist.get_artist_by_id(artist_id)
    if not artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    Action.create_or_increment(name=ActionName.ARTIST_SHOW, user_id=current_user.id, reference_id=artist.id, reference_name=ReferenceClassName.ARTIST)
    
    