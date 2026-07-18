from flask import Blueprint, jsonify, request, render_template
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Action, Artist
from app.model.action import ReferenceClassName, ActionName

rating_bp = Blueprint('rating', __name__)

@rating_bp.get('/ratings')
def rating_page():
    return render_template("ratings.html")

@rating_bp.get('/api/me/ratings')
@jwt_required()
def rating_get_all_for_user():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)
    all_ratings = Rating.get_all_ratings_by_user_id(current_user.id, page, per_page)
    ratings_count = Rating.count_user_ratings(current_user.id)

    results = {"Ratings": [rating.to_dict() for rating in all_ratings],
               "total": ratings_count,
               }


    return jsonify(results), 200

@rating_bp.get('/api/ratings')
def rating_get_all():
    all_ratings = Rating.get_all()
    if not all_ratings:
        return jsonify({"message": "No ratings at the moment!"}), 404

    return jsonify({
        "Ratings": [rating.to_dict() for rating in all_ratings]
    }), 200

@rating_bp.get('/api/artists/<int:artist_id>/songs/<int:song_id>/ratings')
@jwt_required()
def rating_get_all_for_songs(artist_id, song_id):
    existing_artist = Artist.get_artist_by_id(artist_id)
    if not existing_artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    existing_song = Song.get_song_by_id(song_id)
    if not existing_song:
        return jsonify({"error": "Song not found!"}), 404
    
    all_ratings = Rating.get_all_ratings_by_song_id(song_id)

    results = {"Ratings": [rating.to_dict() for rating in all_ratings]}

    return jsonify(results), 200

@rating_bp.get('/api/artists/<int:artist_id>/albums/<int:album_id>/ratings')
@jwt_required()
def rating_get_all_for_album(artist_id, album_id):
    existing_artist = Artist.get_artist_by_id(artist_id)
    if not existing_artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    existing_album = Album.get_album_by_id(album_id)
    if not existing_album:
        return jsonify({"error": "Album not found!"}), 404

    all_ratings = Rating.get_all_ratings_by_album_id(album_id)

    results = {"Ratings": [rating.to_dict() for rating in all_ratings]}

    return jsonify(results), 200

@rating_bp.post('/api/artists/<int:artist_id>/albums/<int:album_id>/ratings')
@jwt_required()
def rating_create_for_album(artist_id, album_id):
    user = current_user
    
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404

    data = request.get_json()

    if not data.get('score'):
        return jsonify({"error": "Missing required fields!", "missing": "score", }), 400
    
    existing_artist = Artist.get_artist_by_id(artist_id)
    if not existing_artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    existing_album = Album.get_album_by_id(album_id)
    if not existing_album:
        return jsonify({"error": "Album not found!"}), 404


    user_id = current_user.id
    rating, errors = Rating.rate_album(artist_id, album_id, data, user_id)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    Action.create_or_increment(name=ActionName.RATE_ALBUM ,user_id=current_user.id, reference_id=album_id, reference_name=ReferenceClassName.ALBUM)

    return jsonify({"message" : "Rating created",
                    "id": rating.id}), 201

@rating_bp.post('/api/artists/<int:artist_id>/songs/<int:song_id>/ratings')
@jwt_required()
def rating_create_for_song(artist_id, song_id):
    user = current_user
    
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404

    data = request.get_json()

    if not data.get('score'):
        return jsonify({"error": "Missing required fields!", "missing": "score", }), 400
    
    existing_artist = Artist.get_artist_by_id(artist_id)
    if not existing_artist:
        return jsonify({"error": "Artist not found!"}), 404
    
    existing_song = Song.get_song_by_id(song_id)
    if not existing_song:
        return jsonify({"error": "Song not found!"}), 404

    user_id = current_user.id
    rating, errors = Rating.rate_song(artist_id, song_id, data, user_id)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    Action.create_or_increment(name=ActionName.RATE_SONG ,user_id=current_user.id, reference_id=song_id, reference_name=ReferenceClassName.SONG)

    return jsonify({"message" : "Rating created",
                    "id": rating.id}), 201


@rating_bp.patch('/api/users/me/ratings/<int:rating_id>')
@jwt_required()
def rating_update_put(rating_id):
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    data = request.get_json()    
    rating = Rating.get_one_rating_by_id(rating_id)

    success, errors = rating.update(data)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code

    return jsonify({"message" : "Rating updated successfully!",
                    "Rating" : rating.to_dict(),
                    }), 200


#shota vpadlu, potim shne)
@rating_bp.delete('/api/users/me/ratings/<int:rating_id>')
@jwt_required()
def rating_delete(rating_id):
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    rating = Rating.get_one_rating_by_id(rating_id)
    if not rating:
        return jsonify({"error": "Rating not found!"}), 404
    success, response = rating.delete()

    status_code = response.pop('code')
    return jsonify(response), status_code