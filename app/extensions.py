from flask_sqlalchemy_lite import SQLAlchemy
from flask_jwt_extended import JWTManager
import redis
import os


db = SQLAlchemy()
jwt = JWTManager()
redis_client = redis.from_url(os.environ.get('REDIS_URL'), health_check_interval=30, socket_keepalive=True)