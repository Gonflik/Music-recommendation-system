from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song

rating_bp = Blueprint('rating', __name__)


@rating_bp.get('/users/<int:user_id>/ratings')
@jwt_required
def rating_get_all_for_user(user_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    ratings = Rating.get_all_ratings_by_user_id(user_id)
    
    return jsonify([rating.to_dict()] for rating in ratings), 200

@rating_bp.get('/users/ratings')
@jwt_required
def rating_get_all(user_id):
    pass

@rating_bp.post('/artists/<int:artist_id>/albums/<int:album_id>/ratings')
@jwt_required
def rating_create_for_album(artist_id, album_id):
    user = current_user
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404

    data = request.get_json()

    required_fields = ['score', 'description']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400
    
    #needs to be finished

@rating_bp.post('/artists/<int:artist_id>/songs/<int:song_id>/ratings')
@jwt_required
def rating_create_for_song(artist_id, song_id):
    pass


#old POST
@rating_bp.post('/rating/<int:user_id>')
@jwt_required
def rating_create(user_id):
    data = request.get_json()
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    score = data.get('score')
    description = data.get('description', 'empty')
    album_id = data.get('album_id')
    song_id = data.get('song_id')

    if score is None:
        return jsonify({"message": "Missing required field!(score)"}), 400

    if album_id is not None and song_id is not None:
        return jsonify({"message": "You can't rate both at once!(album,song)"}), 400
    
    if album_id is None and song_id is None:
        return jsonify({"message": "Missing required fields! (song_id or album_id)!"}), 400
    
    rating = Rating(user_id=user.id, score=score, description=description)

    if album_id:
        album = Album.get_album_by_id(album_id)
        if not album:
            return jsonify({"message": f"No album with id {album_id}"}), 404
        rating.album_id = album_id
    elif song_id:
        song = Song.get_song_by_id(song_id)
        if not song:
            return jsonify({"message": f"No song with id {song_id}"}), 404
        rating.song_id = song_id

    rating.save()
    return jsonify({"message": "Rating succesfully created!"}), 201

@rating_bp.put('/rating/<int:user_id>')
def rating_update_put(user_id):
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    data = request.get_json()

    score = data.get('score')
    description = data.get('description')
    rating_id = data.get('rating_id')

    if score is None or description is None or rating_id is None:
        return jsonify({"message": "Missing required fields!(score, description, rating_id)"}), 400
    

    rating = Rating.get_one_rating_by_id(rating_id)
    if rating:
       if user_id != rating.user_id:
           return jsonify({"message": "Unauthorized! This is not your rating"}), 403
       rating.score = score
       rating.description = description
       rating.save()
       return jsonify({"message": "Rating updated succesfully!"}), 200
    return jsonify({"message": "No rating with such id!"}), 404

@rating_bp.patch('/rating/<int:user_id>')
def rating_update_patch(user_id):
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    data = request.get_json()

    score = data.get('score')
    description = data.get('description')
    rating_id = data.get('rating_id')

    rating = Rating.get_one_rating_by_id(rating_id)

    if rating:
       if user_id != rating.user_id:
           return jsonify({"message": "Unauthorized! This is not your rating"}), 403
       if score:
        rating.score = score
       elif description:
        rating.description = description
       rating.save()
       return jsonify({"message": "Rating updated succesfully!"}), 200
    return jsonify({"message": "No rating with such id!"}), 404


@rating_bp.delete('/rating/<int:user_id>')
def rating_delete(user_id):
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    data = request.get_json()
    rating_id = data.get('rating_id')

    rating = Rating.get_one_rating_by_id(rating_id)

    if rating:
       if user_id != rating.user_id:
           return jsonify({"message": "Unauthorized! This is not your rating"}), 403
       rating.delete()
       return jsonify({"message": "Rating deleted succesfully!"}), 200
    return jsonify({"message": "No rating with such id!"}), 404