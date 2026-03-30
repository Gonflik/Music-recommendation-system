import pytest
from sqlalchemy import select
from app.model import Album, Artist, Song

@pytest.mark.integration
def test_api_album_success(client, auth_data, db_session, mock_deezer_api_response_album):
    headers = auth_data['headers']
    response = client.get('/search?q=If', headers=headers)
    assert response.status_code == 200

    data = response.get_json()
    assert data["Albums"][0]["name"] == "If"
    assert data["Albums"][0]["artist_name"] == "Mindless Self Indulgence"
    assert data["Albums"][0]["artist_id"] == 1

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


@pytest.mark.integration
def test_api_album_empty_response(client, auth_data, db_session, mock_deezer_api_response_album_empty):
    headers = auth_data['headers']
    response = client.get('/search?q=Bebrosiki', headers=headers)
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