from flask import Flask
from flask_sqlalchemy_lite import SQLAlchemy
from model.base import Base

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_prefixed_env()
    db.init_app(app)

    #from controller.artist or sum import artist_bp
    #app.register_blueprint(artist_bp)

    with app.app_context():
        Base.metadata.create_all(db.engine)
    
    return app