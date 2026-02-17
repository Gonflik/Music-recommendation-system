from flask import Blueprint, jsonify, request
from werkzeug.security import generate_password_hash
from app.model import User
from app.model.user import GenderEnum


user_bp = Blueprint('user',__name__)

@user_bp.post('/register')
def user_register():
    data = request.get_json()
    if not data.get('email'):
        return jsonify({"message": "Email required!"}), 400

    user = User.get_user_by_email(data.get('email'))
    if user is not None:
        return jsonify({"error" : "User already exists"}), 409
    
    raw_password = data.get('password')

    if len(raw_password) < 8:
        return jsonify({"error" : "Password is too short!, (min 8 chars)"}), 400

    hashed_pass = generate_password_hash(raw_password)

    new_user = User(
        name = data.get('name'),
        email = data.get('email'),
        age = data.get('age'),
        password = hashed_pass,
        gender = GenderEnum(data.get('gender', 'prefer_not_to_say').lower()),
        location = data.get('location')
    )
    
    
    new_user.save()

    return jsonify({"message" : "User created"}), 201

@user_bp.post('/login')   
def user_login():
    data = request.get_json()
    user = User.get_user_by_email(data.get('email'))
    if not user:
        return jsonify({"message" : "User not found!"}), 404

    if user.check_password(data.get('password')):
        return jsonify({"message": "Logged in!"}), 200
    return jsonify({"message" : "Incorrect password!"}), 401

@user_bp.get('/profile/<int:id>')
def user_profile(id):
    user = User.get_user_by_id(id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    return jsonify({"User" : {
        "email" : user.email,
        "id" : user.id,
        "name" : user.name,
        "age" : user.age,
        "gender": user.gender,
        "location": user.location
    }})

@user_bp.patch('/profile/<int:id>')
def user_update_patch(id):
    data = request.get_json()
    user = User.get_user_by_id(id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
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
                    "User" : {
                        "email" : user.email,
                        "id" : user.id,
                        "name" : user.name,
                        "age" : user.age,
                        "gender" : user.gender,
                        "location" : user.location
                    }
                    }), 200

@user_bp.put('/profile/<int:id>')
def user_update_put(id):
    data = request.get_json()
    user = User.get_user_by_id(id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    if not all(key in data for key in ['name','age','gender','location']):
        return jsonify({"error" : "Missing requiered fields!"}), 400
    
    user.age = data.get('age')
    user.name = data.get('name')
    user.gender = GenderEnum(data.get('gender', 'prefer_not_to_say').lower())
    user.location = data.get('location')

    user.save()

    return jsonify({"message" : "User updated successfully!",
                    "User" : {
                        "email" : user.email,
                        "id" : user.id,
                        "name" : user.name,
                        "age" : user.age,
                        "gender" : user.gender,
                        "location" : user.location
                    }
                    }), 200
    
@user_bp.delete('/profile/<int:id>')
def user_delete(id):
    data = request.get_json()
    user = User.get_user_by_id(id)
    if not user:
        return jsonify({"message" : "User not found!"}), 404
    
    if not data.get('password'):
        return jsonify({"message": "Password required!"}), 400

    if user.check_password(data.get('password')):
        user.delete()
        return jsonify({"message" : "User deleted successfully!"}), 200
    return jsonify({"message" : "Incorrect password!"}), 401
    

