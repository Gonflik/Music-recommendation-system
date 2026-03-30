import pytest
from sqlalchemy import select
from app.model import Artist, Album, Song

@pytest.mark.integration
def test_api_song_success(client, db_session, auth_data, mock_deezer_api_response_song):
    headers = auth_data['headers']
    response = client.get('/search?q=Luv (sic) pt5', headers=headers)
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

@pytest.mark.integration
def test_api_song_empty_response(client, db_session, auth_data, mock_deezer_api_response_song_empty):
    headers = auth_data['headers']
    response = client.get('/search?q=Something-non-existent', headers=headers)
    assert response.status_code == 200

    data = response.get_json()
    assert not data["Songs"]
    assert not data["Artists"]
    assert not data["Albums"]
    
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