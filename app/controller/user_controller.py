from flask import Blueprint, jsonify, request
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt, current_user, get_jwt_identity
from app.model import User, TokenBlocklist
from app.model.user import GenderEnum

user_bp = Blueprint('user',__name__)


#mozna zrobit decorator yakii bude chekat chi user ADMIN, abo prosto if else if else

@user_bp.post('/register')
def user_register():
    data = request.get_json()
    if not data.get('email'):
        return jsonify({"error": "Email required!"}), 400

    user = User.get_user_by_email(data.get('email'))
    if user is not None:
        return jsonify({"error" : "User already exists"}), 409
    
    raw_password = data.get('password')

    if len(raw_password) < 8:
        return jsonify({"error" : "Password is too short!, (min 8 chars)"}), 400

    hashed_pass = User.hash_password(raw_password)

    new_user = User(
        name = data.get('name'),
        email = data.get('email'),
        age = data.get('age'),
        password = hashed_pass,
        gender = GenderEnum(data.get('gender', 'prefer_not_to_say').lower()),
        location = data.get('location'),
        role = data.get('role')
    )
    
    
    new_user.save()

    return jsonify({"message" : "User created"}), 201

@user_bp.post('/login')   
def user_login():
    data = request.get_json()
    user = User.get_user_by_email(data.get('email'))
    if not user:
        return jsonify({"error" : "User not found!"}), 404

    password = data.get('password')
    if User.hash_password(password) == user.password:
        access_token = create_access_token(identity=user.email, additional_claims={"role": user.role}) 
        refresh_token = create_refresh_token(identity=user.email, additional_claims={"role": user.role}) 
        return jsonify({
            "message": "Logged in!",
            "tokens": {
                "access": access_token,
                "refresh": refresh_token
            }
        }), 200
    return jsonify({"error" : "Incorrect password!"}), 401

@user_bp.get('/profile')
@jwt_required()
def user_profile():
    if not current_user:
        return jsonify({"error" : "User not found!"}), 404
    return jsonify(current_user.to_dict())
    
    

@user_bp.get('/all')
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

@user_bp.get('/logout')
@jwt_required(refresh=True)
def user_logout():
    jwt = get_jwt()
    jti = jwt['jti']

    token_block = TokenBlocklist(jti=jti)
    token_block.save()

    return jsonify({"message": "Logged out successfully!"}), 200

@user_bp.patch('/profile')
@jwt_required()
def user_update_patch():
    data = request.get_json()
    user = current_user
    if not user:
        return jsonify({"error" : "User not found!"}), 404
    
    new_name = data.get('name')
    new_age = data.get('age')
    new_gender = data.get('gender').lower()
    new_location = data.get('location')

    if new_name:
        user.name = new_name

    if new_age:
        user.age = new_age

    if new_gender:
        user.gender = GenderEnum(new_gender)
    
    if new_location:
        user.location = new_location

    user.save()
    
    return jsonify({"message" : "User updated successfully!",
                    "User" : user.to_dict(),
                    }), 200

@user_bp.put('/profile')
@jwt_required()
def user_update_put():
    data = request.get_json()
    user = current_user
    if not user:
        return jsonify({"error" : "User not found!"}), 404
    
    if not all(key in data for key in ['name','age','gender','location']):
        return jsonify({"error" : "Missing requiered fields!"}), 400
    
    user.age = data.get('age')
    user.name = data.get('name')
    user.gender = GenderEnum(data.get('gender', 'prefer_not_to_say').lower())
    user.location = data.get('location')

    user.save()

    return jsonify({"message" : "User updated successfully!",
                    "User" : user.to_dict(),
                    }), 200
    
@user_bp.delete('/profile')
@jwt_required()
def user_delete():
    data = request.get_json()
    user = current_user
    if not user:
        return jsonify({"error" : "User not found!"}), 404
    
    password = data.get('password')
    if not password:
        return jsonify({"error": "Password required!"}), 400

    if User.hash_password(password) == user.password:
        user.delete()
        return jsonify({"message" : "User deleted successfully!"}), 200
    return jsonify({"error" : "Incorrect password!"}), 401
    

