from flask import Blueprint, jsonify, request, url_for
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action
from app.model.action import ActionName, ReferenceClassName
from ..services.propaganda import PropagandaDranika

explore_bp = Blueprint('explore', __name__)


@explore_bp.get('/explore')
@jwt_required()
def explore():
    user = current_user
    if not user:
        return jsonify({"message": "User not found!"}), 404

    recommendations = PropagandaDranika.get_recommendations(user.id, 5)
    if not recommendations:
        return jsonify({"message": "No recommendations!"}), 404

    return jsonify({
        "Recommendations": [i.to_dict() for i in recommendations],
        "links": {
            "search": url_for('search.search')
        }
    })


