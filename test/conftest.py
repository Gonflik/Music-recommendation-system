import pytest
import json
from unittest.mock import patch
from app.model import Base
from app import create_app, db
from .factories import all_factories




@pytest.fixture(scope="function")
def app():
    params = {
        'SQLALCHEMY_ENGINES': {"default": "postgresql+psycopg://testdranik:dranik322@localhost:5432/testdb"},
        "SECRET_KEY": "asdadadadadadada",
        "JWT_SECRET_KEY": "123sahfu2748fu1273y18y1diuhfhwd19828e19eu198e1298ssuf1283"
    }
    _app = create_app(test_config=params)
    with _app.app_context():
        yield _app

@pytest.fixture(scope="function")
def engine():
    return db.engine
    
@pytest.fixture(scope="function")
def client(app):
    return app.test_client()

@pytest.fixture(scope="session", autouse=True)
def setup_db():
    app = create_app(
        test_config={
            "SQLALCHEMY_ENGINES": {
                "default": "postgresql+psycopg://testdranik:dranik322@localhost:5432/testdb"
            }
        }
    )

    with app.app_context():
        Base.metadata.create_all(db.engine)
        yield
        Base.metadata.drop_all(db.engine)

@pytest.fixture(scope="function", autouse=True) #maybe delete autouse if something
def db_session(app, engine):
    connection = engine.connect()
    transaction = connection.begin()

    session = db.session
    session.bind = connection
    for factory_class in all_factories:
        factory_class._meta.sqlalchemy_session = session

    yield session

    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture
def mock_user_data():
    return {
        "name": "Danik",
        "email": "danylo@gmail.com",
        "password": "danylo12345",
        "age": 14
    }

@pytest.fixture
def auth_data(client, mock_user_data):
    register_response = client.post('/users', data=json.dumps(mock_user_data), 
                           headers={"Content-Type": "application/json"})
    assert register_response.status_code == 201
    user_id = register_response.get_json().get('id')

    login_data = {
        "email": "danylo@gmail.com",
        "password": "danylo12345"
    }
    response = client.post('/users/login', data=json.dumps(login_data), headers={"Content-Type": "application/json"})
    assert response.status_code == 200

    data = response.get_json()
    access_token = data['tokens']['access']
    refresh_token = data['tokens']['refresh']
    return {
        "headers": {'Authorization': f"Bearer {access_token}"},
        "user_id": user_id,
        "refresh": refresh_token
    }

@pytest.fixture
def mock_api_artist_data():
    return 


@pytest.fixture
def mock_api_response(mock_api_artist_data):
    with patch('app.services.musicbrainz_client.musicbrainzngs.search_artists') as mock_search:
        mock_search.return_value = {
            'artist-list': [
                {
                    "name": "Bobrik",
                    "foreign_name": "Бобрік",
                    "disambiguation": "Aspiring artist",
                    "id": "12314jdnfjf-asndadn12-12ksdfks",
                    "alias-list": [{"alias": "bobr"}]
                } 
            ]
        }
        yield mock_search

@pytest.fixture
def mock_api_response_none(mock_api_artist_data):
    with patch('app.services.musicbrainz_client.musicbrainzngs.search_artists') as mock_search:
        mock_search.return_value = {
            "artist-list": None
        }
        yield mock_search