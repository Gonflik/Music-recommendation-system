from flask import Blueprint, jsonify, request
from app.model import Rating, User, Album, Song

rating_bp = Blueprint('rating', __name__)


@rating_bp.get('/rating/<int:user_id>')
def rating_get(user_id):
    entries = Rating.get_all_ratings_by_user_id(user_id)
    results = []
    for entry in entries:
        if entry.album is not None:
            obj = entry.album
            artist_name = [obj.artist.name]
        else:
            obj = entry.song
            artist_name = [artist.name for artist in obj.artist]
        results.append({
            "id": entry.id,
            "score": entry.score,
            "description": entry.description,
            f"{obj.__class__.__name__}": {
                "id": obj.id,
                "name": obj.name,
                "length": obj.length,
                "artist_name": artist_name,
            },
        })
    return jsonify(results)


@rating_bp.post('/rating/<int:user_id>')
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