from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song

rating_bp = Blueprint('rating', __name__)


@rating_bp.get('/users/<int:user_id>/ratings')
@jwt_required()
def rating_get_all_for_user(user_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)
    all_ratings = Rating.get_all_ratings_by_user_id(user_id, page, per_page)
    
    results = {"Ratings": [rating.to_dict() for rating in all_ratings]}

    return jsonify(results), 200

@rating_bp.get('/users/ratings')
@jwt_required()
def rating_get_all():
    pass

@rating_bp.post('/artists/<int:artist_id>/albums/<int:album_id>/ratings')
@jwt_required()
def rating_create_for_album(artist_id, album_id):
    user = current_user
    
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404

    data = request.get_json()

    if not data.get('score'):
        return jsonify({"error": "Missing required fields!", "missing": "score", }), 400
    
    user_id = current_user.id
    rating, errors = Rating.rate_album(artist_id, album_id, data, user_id)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    return jsonify({"message" : "Rating created",
                    "id": rating.id}), 201

@rating_bp.post('/artists/<int:artist_id>/songs/<int:song_id>/ratings')
@jwt_required()
def rating_create_for_song(artist_id, song_id):
    user = current_user
    
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404

    data = request.get_json()

    if not data.get('score'):
        return jsonify({"error": "Missing required fields!", "missing": "score", }), 400
    
    user_id = current_user.id
    rating, errors = Rating.rate_song(artist_id, song_id, data, user_id)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    return jsonify({"message" : "Rating created",
                    "id": rating.id}), 201


@rating_bp.put('/users/<int:user_id>/ratings/<int:rating_id>')
@jwt_required()
def rating_update_put(user_id, rating_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    data = request.get_json()
    required_fields = ['score','description']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400
    
    rating = Rating.get_one_rating_by_id(rating_id)

    success, errors = rating.update(data)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code

    return jsonify({"message" : "Rating updated successfully!",
                    "Rating" : rating.to_dict(),
                    }), 200


#shota vpadlu, potim shne)
@rating_bp.delete('/users/<int:user_id>/ratings/<int:rating_id>')
@jwt_required()
def rating_delete(user_id, rating_id):
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    rating = Rating.get_one_rating_by_id(rating_id)
    if not rating:
        return jsonify({"error": "Rating not found!"}), 404
    success, response = rating.delete()

    status_code = response.pop('code')
    return jsonify(response), status_code