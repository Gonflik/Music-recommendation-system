from flask import Flask, Blueprint
from .extensions import db
from .model.base import Base
from .controller.user_controller import user_bp
from .controller.tolisten_controller import tolisten_bp



def create_app():
    app = Flask(__name__)
    app.config.from_prefixed_env()
    db.init_app(app)


    app.register_blueprint(user_bp, url_prefix='/user')
    app.register_blueprint(tolisten_bp, url_prefix='/user')

    with app.app_context():
        Base.metadata.create_all(db.engine)
    
    return app