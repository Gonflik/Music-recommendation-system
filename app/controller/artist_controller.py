from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist

artist_bp = Blueprint('artist', __name__)

@artist_bp.get('/artists')
@jwt_required()
def artist_index():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    

    