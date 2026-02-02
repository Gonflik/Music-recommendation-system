from flask import Blueprint
from app.model.user import User
from app import db
from sqlalchemy import select

user_bp = Blueprint('user', __name__)

@user_bp.route('/user')
def get_user():
    pass

@user_bp.route('/user/create')
def create_user():
    pass

@user_bp.route('/user/something')
def something():
    pass

#how to pass json
#how to decode and use json
#what routes do i need for my app(models)
