from flask import Blueprint, jsonify, request, url_for
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Genre

genre_bp = Blueprint('genre', __name__)

@genre_bp.get('/api/genres/<int:genre_id>')
def genre_show(genre_id):
    genre = Genre.get_by_id(genre_id)
    if not genre:
        return jsonify({"error": "Genre not found!"}), 404
    genre_dict = genre.to_dict()
    genre_dict["links"] = {"index": url_for('genre.genre_index')}
    return jsonify({"Genre": genre_dict})


@genre_bp.get('/api/genres')
def genre_index():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)
    
    genres = Genre.get_all(per_page, page)
    if not genres:
        return jsonify({"error": "Not found!"}), 404
    result = []
    for g in genres:
        result.append({"Genre":{
            "name": g.name,
            "id": g.id,
            "dzid": g.dzid,
            "links": {"show": url_for('genre.genre_show', genre_id = g.id)}
            }
        })
    result.append({
        "links": {
            "next_page": url_for('genre.genre_index', page = page + 1, per_page = per_page),
            "prev_page": url_for('genre.genre_index', page = (page - 1) if page - 1 != 0 else page, per_page=per_page)
        },
    })

    return jsonify(result), 200


    


