from flask import Blueprint, jsonify, request, url_for, render_template
from flask_jwt_extended import jwt_required, current_user, get_jwt_identity
from app.model import Rating, User, Album, Song, Artist, Action, ToListen
from app.model.action import ActionName, ReferenceClassName

album_bp = Blueprint('album', __name__)

@album_bp.get('/albums')
@jwt_required()
def album_index():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)

    #Album.get

@album_bp.get('/albums/<int:album_id>')
def album_show_page(album_id):
    return render_template("album_show.html", album_id=album_id)

@album_bp.get('/api/albums/<int:album_id>')
@jwt_required()
def album_show(album_id):
    album = Album.get_album_by_id(album_id, load_songs=True)
    if not album:
        return jsonify({"error": "Album not found!"}), 404
    
    Action.create_or_increment(name=ActionName.ALBUM_SHOW ,user_id=current_user.id, reference_id=album.id, reference_name=ReferenceClassName.ALBUM)

    songs_out = []
    for song in album.songs:
        d = song.to_dict()
        rating = Rating.get_by_song_user_id(song.id, current_user.id)
        d["user_rating"] = rating.score if rating else None
        songs_out.append(d)


    album_dict = album.to_dict()    
    album_dict["Songs"] = sorted(songs_out, key=lambda s: s.get('song_position') or 0)

    already_saved = ToListen.exists_for_user(user_id=current_user.id, album_id=album_id)
    album_dict["in_tolisten"] = already_saved

    user_album_rating = Rating.get_by_album_user_id(album.id, current_user.id)

    return jsonify({"Album": album_dict,
                    "user_album_rating": {
                        "score": user_album_rating.score,
                        "description": user_album_rating.description,
                    } if user_album_rating else None
                    })
