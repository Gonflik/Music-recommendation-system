from flask import Blueprint, jsonify, request, url_for, render_template
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action
from app.model.action import ActionName, ReferenceClassName
from ..services.propaganda import PropagandaDranika

explore_bp = Blueprint('explore', __name__)

@explore_bp.get('/explore')
def explore_page():
    return render_template("explore.html")

@explore_bp.get('/api/explore')
@jwt_required()
def explore():
    user = current_user
    if not user:
        return jsonify({"message": "User not found!"}), 404

    genre_filter = request.args.get("genre", default=None, type=str)

    popular_albums = Album.get_popular(limit=8, genre=genre_filter)
    recommendations = PropagandaDranika.get_recommendations(user.id, 5)
    if not recommendations:
        return jsonify({"message": "No recommendations!"}), 404

    return jsonify({
        "Recommendations": [i.to_dict() for i in recommendations],
        "Popular": [i.to_dict() for i in popular_albums],
        "links": {
            "search": url_for('search.search')
        }
    })

@explore_bp.get('/')
def index():
    return render_template("index.html")
