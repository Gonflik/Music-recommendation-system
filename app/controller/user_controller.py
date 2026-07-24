from flask import Blueprint, jsonify, request, render_template, redirect, url_for
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt, current_user, get_jwt_identity
from app.model import User, TokenBlocklist
from app.model.user import GenderEnum

user_bp = Blueprint('user',__name__)


@user_bp.get('/users')
def register_page():
    return render_template("register.html")

@user_bp.post('/api/users')
def user_register():
    data = request.get_json()
    required_fields = ['email', 'password', 'name']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing}), 400
    
    user, errors = User.register(data)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code

    return jsonify({"message" : "User created",
                    "id": user.id}), 201

@user_bp.get('/users/login')
def login_page():
    return render_template("login.html")

@user_bp.post('/api/users/login')   
def user_login():
    data = request.get_json()
    required_fields = ['email', 'password']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400

    user, errors = User.login(data)

    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    access_token = create_access_token(identity=user.email, additional_claims={"role": user.role}) 
    refresh_token = create_refresh_token(identity=user.email, additional_claims={"role": user.role})

    return jsonify({
            "message": "Logged in!",
            "tokens": {
                "access": access_token,
                "refresh": refresh_token
            },
            "user_id": user.id,
        }), 200

@user_bp.get('/api/users/<int:user_id>')
@jwt_required()
def user_info(user_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    return jsonify(current_user.to_dict()), 200

@user_bp.get('/users/<int:user_id>')
def user_page(user_id):
    return render_template("profile.html", profile_user_id=user_id)

@user_bp.get('/users/profile')  
@jwt_required()
def user_profile_redirect():
    return redirect(url_for('user.user_page', user_id=current_user.id))

@user_bp.get('/api/users/<int:user_id>/profile')
@jwt_required()
def user_profile(user_id):
    from ..model.rating import Rating
    from ..model.tolisten import ToListen

    target_user = User.get_user_by_id(user_id)
    if not target_user:
        return jsonify({"error": "User not found!"}), 404

    recent_ratings = Rating.get_users_recent(user_id)
    recent_tolisten = ToListen.get_users_recent(user_id)

    total_ratings = Rating.count_user_ratings(user_id)
    tolisten_count = ToListen.count_user_tolisten(user_id)

    song_count, album_count = Rating.count_user_song_album_ratings(user_id)

    return jsonify({"User": target_user.to_dict(),
                    "stats": {
                        "ratings_count": total_ratings,
                        "albums_rated": album_count,
                        "songs_rated": song_count,
                        "tolisten_count": tolisten_count,
                    },
                    "recent_ratings": [r.to_dict() for r in recent_ratings],
                    "recent_tolisten": [r.to_dict() for r in recent_tolisten],
                    })

@user_bp.get('/api/users')
@jwt_required()
def user_get_all():
    claims = get_jwt()
    
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=5, type=int)
    all_users = User.get_all_users(page, per_page)
    results = {"Users": [user.to_dict() for user in all_users]}
    return jsonify(results), 200

@user_bp.get('/refresh')
@jwt_required(refresh=True)
def refresh_access():
    identity = get_jwt_identity()
    new_access_token = create_access_token(identity=identity)
    return jsonify({"access_token": new_access_token})

@user_bp.get('/users/logout')
@jwt_required(refresh=True)
def user_logout():
    jwt = get_jwt()
    jti = jwt['jti']

    token_block = TokenBlocklist(jti=jti)
    token_block.save()

    return jsonify({"message": "Logged out successfully!"}), 200

@user_bp.patch('/api/users/<int:user_id>')
@jwt_required()
def user_update_put(user_id):
    if user_id != current_user.id:
        return jsonify({"message": "You are not authorized to access this!"}), 403
    
    data = request.get_json()
    success, errors = current_user.update(data)
    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code

    return jsonify({"message" : "User updated successfully!",
                    "User" : current_user.to_dict(),
                    }), 200
    
    
@user_bp.delete('/api/users/<int:user_id>')
@jwt_required()
def user_delete(user_id):
    data = request.get_json()
    if user_id != current_user.id:
        return jsonify({"message": "You are not authorized to access this!"}), 403
    
    required_fields = ['password']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400
    
    success, response = current_user.delete(data)

    status_code = response.pop('code')
    return jsonify(response), status_code
    
    