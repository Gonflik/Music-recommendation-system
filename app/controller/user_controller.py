from flask import Blueprint, jsonify, request
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt, current_user, get_jwt_identity
from app.model import User, TokenBlocklist
from app.model.user import GenderEnum

user_bp = Blueprint('user',__name__)


#mozna zrobit decorator yakii bude chekat chi user ADMIN, abo prosto if else if else

@user_bp.post('/users')
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

@user_bp.post('/users/login')   
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
            }
        }), 200

@user_bp.get('/users/<int:user_id>')
@jwt_required()
def user_profile(user_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() == current_user.email:
        return jsonify(current_user.to_dict()), 200
    return jsonify({"message": "You are not authorized to access this!"}), 401
    
    

@user_bp.get('/users')
@jwt_required()
def user_get_all():
    claims = get_jwt()
    if claims.get('role') == "admin":
        page = request.args.get('page', default=1, type=int)
        per_page = request.args.get('per_page', default=5, type=int)
        all_users = User.get_all_users(page, per_page)
        results = {"Users": [user.to_dict() for user in all_users]}
        return jsonify(results), 200
    return jsonify({"message": "You are not authorized to access this!"}), 401

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

"""@user_bp.patch('/profile')
@jwt_required()
def user_update_patch():
    user = current_user
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    data = request.get_json()
    success, errors = user.update(data)
    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code
    
    return jsonify({"message" : "User updated successfully!",
                    "User" : user.to_dict(),
                    }), 200"""

@user_bp.put('/users/<int:user_id>')
@jwt_required()
def user_update_put(user_id):
    current_user = User.get_user_by_id(user_id)
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    data = request.get_json()
    required_fields = ['name','age','gender','location']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400
    
    success, errors = current_user.update(data)
    if errors:
        status_code = errors.pop('code', 400)
        return jsonify(errors), status_code

    return jsonify({"message" : "User updated successfully!",
                    "User" : current_user.to_dict(),
                    }), 200
    
    #user model has more attributes, do i need to put all of them, rn its only the NOT NULL ones
    
@user_bp.delete('/users/<int:user_id>')
@jwt_required()
def user_delete(user_id):
    data = request.get_json()
    user = User.get_user_by_id(user_id)
    if not user:
        return jsonify({"error" : "User not found!"}), 404
    
    if get_jwt_identity() != current_user.email:
        return jsonify({"message": "You are not authorized to access this!"}), 401
    
    required_fields = ['password']
    missing = [miss for miss in required_fields if miss not in data]
    if missing:
        return jsonify({"error": "Missing required fields!", "missing": missing, }), 400
    
    success, response = user.delete(data)

    status_code = response.pop('code')
    return jsonify(response), status_code
    
    