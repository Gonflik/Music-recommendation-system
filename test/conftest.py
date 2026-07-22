import pytest
import json
import datetime
from unittest.mock import patch, MagicMock
from app.model import Base, Album, Artist
from app import create_app, db
from .factories import all_factories
from types import SimpleNamespace
from sqlalchemy import select


#docker compose --profile test up -d db_test

#docker compose --profile test stop db_test

@pytest.fixture(scope="session")
def app():
    params = {
        "SQLALCHEMY_ENGINES": {
            "default": "postgresql+psycopg://testdranik:dranik322@localhost:5433/for_pytest"
        },
        "SECRET_KEY": "asdadadadadadada",
        "JWT_SECRET_KEY": "123sahfu2748fu1273y18y1diuhfhwd19828e19eu198e1298ssuf1283",
    }
    app = create_app(test_config=params)
    yield app
    
@pytest.fixture(scope="function")
def client(app):
    return app.test_client()

@pytest.fixture(scope="session", autouse=True)
def setup_db(app):
    with app.app_context():
        Base.metadata.create_all(db.engine)
        yield
        Base.metadata.drop_all(db.engine)

@pytest.fixture(scope="function", autouse=True) #maybe delete autouse if something
def db_session(app):
    with app.app_context():
        yield db.session
        db.session.rollback()
        for table in reversed(Base.metadata.sorted_tables):
            db.session.execute(table.delete())
        db.session.commit()

    for factory_class in all_factories:
        factory_class._meta.sqlalchemy_session = db.session


@pytest.fixture
def mock_user_data():
    return {
        "name": "Danik",
        "email": "danylo@gmail.com",
        "password": "danylo12345",
        "age": 14
    }

@pytest.fixture
def mock_user_data2():
    return {
        "name": "Maxon",
        "email": "maxon@gmail.com",
        "password": "maxon12345",
        "age": 18
    }

@pytest.fixture
def auth_data(client, mock_user_data):
    register_response = client.post('/api/users', data=json.dumps(mock_user_data), 
                           headers={"Content-Type": "application/json"})
    assert register_response.status_code == 201
    user_id = register_response.get_json().get('id')

    login_data = {
        "email": "danylo@gmail.com",
        "password": "danylo12345"
    }
    response = client.post('/api/users/login', data=json.dumps(login_data), headers={"Content-Type": "application/json"})
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
def auth_data2(client, mock_user_data2):
    register_response = client.post('/api/users', data=json.dumps(mock_user_data2), 
                           headers={"Content-Type": "application/json"})
    assert register_response.status_code == 201
    user_id = register_response.get_json().get('id')

    login_data = {
        "email": "maxon@gmail.com",
        "password": "maxon12345"
    }
    response = client.post('/api/users/login', data=json.dumps(login_data), headers={"Content-Type": "application/json"})
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
def mock_deezer_client():
    with patch('app.services.deezer_client.deezer.Client') as mock_class:
        fake_instance = MagicMock()
        mock_class.return_value.__enter__.return_value = fake_instance
        yield fake_instance

@pytest.fixture
def mock_deezer_api_response_artist(mock_deezer_client):
    fake_artist = MagicMock()

    fake_artist.id = 27
    fake_artist.name = "mass of the fermenting dregs"
    fake_artist.picture = "https://api.deezer.com/artist/27/image"
    fake_artist.nb_album = 4

    mock_deezer_client.search_artists.return_value = [fake_artist]

    return fake_artist

@pytest.fixture
def mock_deezer_api_response_artist_empty(mock_deezer_client):
    fake_artist = []

    mock_deezer_client.search_artists.return_value = fake_artist
    return fake_artist

@pytest.fixture
def mock_deezer_api_response_song(mock_deezer_client):
    fake_song = SimpleNamespace(
        title="Luv (sic) pt5",
        id = 10293,
        duration = 350,
        track_position = 6,
        preview = "https://bebrabebra.music",
        artist=SimpleNamespace(
            name="Nujabes",
            id = 12317,
            picture = "https://fakeartistpicture.music.pictures",
            nb_album = 6
        ),
        album=SimpleNamespace(
            title="Luv (sic) hexalogy",
            id = 6246234,
            cover_xl = "https://picturealbumshne.music",
        )
    )
    
    fake_album = SimpleNamespace(
        title="Luv (sic) hexalogy",
        id = 6246234,
        duration = 3200,
        cover_xl = "https://picturealbumshne.music",
        track_position = 67,
        nb_tracks = 52,
        preview = "https://preview.music",
        genres = [
            SimpleNamespace(name="Hip-hop", id=77)
        ],
        artist = SimpleNamespace(
            name = "Nujabes",
            id = 12317,
            nb_album = 7,
            picture = "https://fakeartistpicture.music.pictures"
        ),
        release_date = datetime.date(2067, 4, 29),
        record_type = "album",
    )

    mock_deezer_client.search.return_value = [fake_song]
    mock_deezer_client.get_album.return_value = fake_album

    return {
        "song": fake_song,
        "album": fake_album,
    }

@pytest.fixture
def mock_deezer_api_response_song_empty(mock_deezer_client):
    fake_song = []

    mock_deezer_client.search.return_value = fake_song

    return fake_song

@pytest.fixture
def mock_deezer_api_response_album(mock_deezer_client):
    fake_album = SimpleNamespace(
        title = "If",
        id = 30212,
        duration = 2700,
        cover_xl = "https://somepicturetypeshit.music.com",
        nb_tracks = 6767,
        genres = [
            SimpleNamespace(name="Synth-punk", id=67)
        ],
        artist = SimpleNamespace(
            name = "Mindless Self Indulgence",
            id = 6767,
            picture = "https://msipictureshnee.com.music.com",
            nb_album= 5,
        ),
        release_date = datetime.date(2067, 4, 29),
        record_type = "album"
    )

    mock_deezer_client.search_albums.return_value = [fake_album]

    return fake_album

@pytest.fixture
def mock_deezer_api_response_album_nujabes(mock_deezer_client):
    fake_album = SimpleNamespace(
        title = "Luv (sic) hexalogy",
        id = 6246234,
        duration = 2700,
        cover_xl = "https://somepicturetypeshit.music.com",
        nb_tracks = 6767,
        genres = [
            SimpleNamespace(name="Hip-hop", id=52)
        ],
        artist = SimpleNamespace(
            name = "Nujabes",
            id = 12317,
            picture = "https://msipictureshnee.com.music.com",
        ),
        release_date = datetime.date(2008, 4, 29),
        record_type = "album"
    )

    mock_deezer_client.search_albums.return_value = [fake_album]

    return fake_album

@pytest.fixture
def mock_deezer_api_response_album_empty(mock_deezer_client):
    fake_album = []

    mock_deezer_client.search_albums.return_value = fake_album

    return fake_album

@pytest.fixture
def mock_deezer_api_response_album_get_tracks(mock_deezer_client):
    fake_song = SimpleNamespace(
        title="Luv (sic) pt5",
        id = 10293,
        duration = 350,
        track_position = 6,
        preview = "https://bebrabebra.music",
        artist=SimpleNamespace(
            name="Nujabes",
            id = 12317,
            picture = "https://fakeartistpicture.music.pictures",
        ),
        album=SimpleNamespace(
            title="Luv (sic) hexalogy",
            id = 6246234,
            cover = "https://picturealbumshne.music",
        )
    )

    fake_song_2 = SimpleNamespace(
        title="Luv (sic) pt6",
        id = 10295,
        duration = 332,
        track_position = 7,
        preview = "https://bebrabebra.music",
        artist=SimpleNamespace(
            name="Nujabes",
            id = 12317,
            picture = "https://fakeartistpicture.music.pictures",
        ),
        album=SimpleNamespace(
            title="Luv (sic) hexalogy",
            id = 6246234,
            cover = "https://picturealbumshne.music",
        )
    )
    fake_album = SimpleNamespace(
        title = "Luv (sic) hexalogy",
        id = 6246234,
        duration = 2700,
        cover = "https://somepicturetypeshit.music.com",
        nb_tracks = 6767,
        genres = [
            SimpleNamespace(name="Hip-hop", id=52)
        ],
        artist = SimpleNamespace(
            name = "Nujabes",
            id = 12317,
            picture = "https://msipictureshnee.com.music.com",
        ),
    )
    def get_tracks():
        return [fake_song, fake_song_2]
    
    fake_album.get_tracks = get_tracks
    mock_deezer_client.get_album.return_value = fake_album
    

    return fake_song, fake_song_2


@pytest.fixture
def created_rating(client, auth_data, db_session, mock_deezer_api_response_album):
    headers = auth_data['headers']
    
    client.get('/api/search?q=If', headers=headers)
    album = db_session.execute(
        select(Album).where(Album.dzid == 30212)
    ).scalar_one_or_none()
    artist = db_session.execute(
        select(Artist).where(Artist.dzid == 6767)
    ).scalar_one_or_none()

    response = client.post(
        f'/api/artists/{artist.id}/albums/{album.id}/ratings',
        headers=headers,
        json={"score": 10, "description": "pretty good"}
    )
    assert response.status_code == 201
    return {
        "rating_id": response.get_json()['id'],
        "artist_id": artist.id,
        "album_id": album.id,
    }