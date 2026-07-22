import pytest
from sqlalchemy import select
from app.model import Album, Artist

def create_rating_album_successfull(client, auth_data, db_session, mock_deezer_api_response_album):
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
        json={"score": 8, "description": "pretty good"}
    )
    assert response.status_code == 201

def create_rating_song_successfull(client, auth_data, db_session, mock_deezer_api_response_album):
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
        json={"score": 8, "description": "pretty good"}
    )
    assert response.status_code == 201


