from flask import Flask, jsonify
from .extensions import db, jwt
from .model.base import Base
from .model import User, TokenBlocklist
from .controller.genre_controller import genre_bp
from .controller.user_controller import user_bp
from .controller.tolisten_controller import tolisten_bp
from .controller.rating_controller import rating_bp
from .controller.search_controller import search_bp
from .controller.album_controller import album_bp
from flask_migrate import Migrate


def create_app(test_config=None):
    app = Flask(__name__)

    if test_config:
        app.config.update(test_config)
    else:
        app.config.from_prefixed_env()

    
    db.init_app(app)
    jwt.init_app(app)
    
    app.register_blueprint(user_bp)
    app.register_blueprint(tolisten_bp)
    app.register_blueprint(rating_bp)
    app.register_blueprint(search_bp)
    app.register_blueprint(genre_bp)
    app.register_blueprint(album_bp)


    # if test_config:
    #     pass
    # else:
    #     with app.app_context(): 
    #         Base.metadata.create_all(db.engine)        

    migrate = Migrate(app=app, db=db)

    #jwt user loader
    @jwt.user_lookup_loader
    def user_lookup_callback(_jwt_header,jwt_data):
        identity = jwt_data['sub']
        return User.get_user_by_email(identity)


    #jwt error handlers
    @jwt.expired_token_loader
    def expired_token_callback(jwt_header, jwt_data):
        return jsonify({
            "message": "Token has expired!", 
            "error": "token_expired"
            }), 401

    @jwt.invalid_token_loader
    def invalid_token_callback(error):
        return jsonify({
            "message": "Signature verification failed!", 
            "error": "invalid_token"
            }), 401
    
    @jwt.unauthorized_loader
    def missing_token_callback(error):
        return jsonify({
            "message": "Request doesnt contain a valid token!", 
            "error": "authorization_required"
            }), 401
    
    @jwt.token_in_blocklist_loader
    def token_in_blocklist_callback(jwt_header, jwt_data):
        if jwt_data['type'] == 'refresh':   
            jti = jwt_data['jti']
            token = TokenBlocklist.select_token_by_jti(jti)
            return token is not None
        return False
    return app