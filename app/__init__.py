from flask import Flask
from .extensions import db
from .model.base import Base
from .controller.user_controller import user_bp


def create_app():
    app = Flask(__name__)
    app.config.from_prefixed_env()
    db.init_app(app)

    #from controller.artist or sum import artist_bp
    #app.register_blueprint(artist_bp)

    app.register_blueprint(user_bp, url_prefix='/user')


    with app.app_context():
        Base.metadata.create_all(db.engine)
    
    return app