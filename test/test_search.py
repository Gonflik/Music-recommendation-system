import pytest
from sqlalchemy import select
from app.model import Album, Artist, Song

def test_search_album_success(client, auth_data, db_session, mock_deezer_api_response_album):
    headers = auth_data['headers']
    response = client.get('/api/search?q=If', headers=headers)
    print(response.get_json())
    assert response.status_code == 200

    data = response.get_json()
    assert data["Albums"][0]["name"] == "If"
    assert data["Albums"][0]["artist_name"] == "Mindless Self Indulgence"

    artist = db_session.execute(
        select(Artist).where(Artist.dzid == 6767)
    ).scalar_one_or_none()

    album = db_session.execute(
        select(Album).where(Album.dzid == 30212)
    ).scalar_one_or_none()

    assert album is not None
    assert album.name == "If"

    assert artist is not None
    assert artist.name == "Mindless Self Indulgence"


def test_search_album_empty_response(client, auth_data, db_session, mock_deezer_api_response_album_empty):
    headers = auth_data['headers']
    response = client.get('/api/search?q=Bebrosiki', headers=headers)
    assert response.status_code == 404
    
    song = db_session.execute(
        select(Song)
    ).scalar_one_or_none()

    artist = db_session.execute(
        select(Artist)
    ).scalar_one_or_none()

    album = db_session.execute(
        select(Album)
    ).scalar_one_or_none()
    
    assert song is None
    assert artist is None
    assert album is None

def test_search_artist_success(client, mock_deezer_api_response_artist, auth_data):
    headers = auth_data['headers']
    response = client.get('/api/search?q=MASS OF THE FERMENTING DREGS', headers=headers)
    assert response.status_code == 200

    data = response.get_json()
    assert data["Artists"][0]["name"] == "mass of the fermenting dregs"
    assert data["Artists"][0]["dzid"] == 27

def test_search_artist_empty_response(client, mock_deezer_api_response_artist_empty, auth_data):
    headers = auth_data['headers']
    response = client.get('/api/search?q=MASS OF THE FERMENTING DREGS', headers=headers)
    assert response.status_code == 404

def test_api_song_success(client, db_session, auth_data, mock_deezer_api_response_song):
    headers = auth_data['headers']
    response = client.get('/api/search?q=Luv (sic) pt5', headers=headers)
    assert response.status_code == 200

    data = response.get_json()
    assert data["Songs"][0]["name"] == "Luv (sic) pt5"
    assert data["Songs"][0]["artist_name"] == "Nujabes"
    assert data["Songs"][0]["album_name"] == "Luv (sic) hexalogy"

    artist = db_session.execute(
        select(Artist).where(Artist.dzid == 12317)
    ).scalar_one_or_none()

    album = db_session.execute(
        select(Album).where(Album.dzid == 6246234)
    ).scalar_one_or_none()

    assert artist is not None
    assert artist.name == "Nujabes"

    assert album is not None
    assert album.name == "Luv (sic) hexalogy"

def test_api_song_empty_response(client, db_session, auth_data, mock_deezer_api_response_song_empty):
    headers = auth_data['headers']
    response = client.get('/api/search?q=Something-non-existent', headers=headers)
    assert response.status_code == 404

    song = db_session.execute(
        select(Song)
    ).scalar_one_or_none()

    artist = db_session.execute(
        select(Artist)
    ).scalar_one_or_none()

    album = db_session.execute(
        select(Album)
    ).scalar_one_or_none()
    
    assert song is None
    assert artist is None
    assert album is None