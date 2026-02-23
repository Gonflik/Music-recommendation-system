import pytest
from app.model import Base
from app import create_app, db
from .factories import all_factories




@pytest.fixture(scope="session")
def app():
    params = {
        'SQLALCHEMY_ENGINES': {"default": "postgresql+psycopg://testdranik:dranik322@localhost:5432/testdb"}
    }
    _app = create_app(test_config=params)
    return _app

@pytest.fixture(scope="session")
def engine(app):
    with app.app_context():
        return db.engine

@pytest.fixture(scope="session", autouse=True)
def setup_db(app, engine):
    with app.app_context():
        Base.metadata.create_all(engine)
        yield
        Base.metadata.drop_all(engine)

@pytest.fixture(scope="function")
def db_session(app, engine):
    with app.app_context():
        connection = engine.connect()
        transaction = connection.begin()

        session = db.session
        for factory_class in all_factories:
            factory_class._meta.sqlalchemy_session = session

        yield session

        session.close()
        transaction.rollback()
        connection.close()
