import pytest
from sqlalchemy import select
from app.model import Album, Artist, Rating

def test_create_rating_album_successfull(client, auth_data, db_session, mock_deezer_api_response_album):
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

def test_create_rating_song_successfull(client, auth_data, db_session, mock_deezer_api_response_album):
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

def test_rating_duplicate(client, auth_data, db_session, mock_deezer_api_response_album):
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

    response = client.post(
            f'/api/artists/{artist.id}/albums/{album.id}/ratings',
            headers=headers,
            json={"score": 8, "description": "pretty good"}
        )

    assert response.status_code == 400

def test_rating_score_out_of_range(client, auth_data, db_session, mock_deezer_api_response_album):
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
            json={"score": 11, "description": "pretty good"}
        )
    assert response.status_code == 400


def test_update_rating_success(client, auth_data, created_rating):
    headers = auth_data['headers']
    rating_id = created_rating["rating_id"]

    response = client.patch(
        f'/api/users/me/ratings/{rating_id}',
        headers=headers,
        json={"description": "labubu"}
    )
    assert response.status_code == 200
    assert response.get_json()["Rating"]["description"] == "labubu"


def test_update_rating_diff_user_failure(client, auth_data2, created_rating):
    headers = auth_data2['headers']
    rating_id = created_rating["rating_id"]

    response = client.patch(
        f'/api/users/me/ratings/{rating_id}',
        headers=headers,
        json={"description": "labubu"}
    )
    assert response.status_code == 403

def test_delete_rating_success(client, auth_data, created_rating, db_session):
    headers = auth_data['headers']
    rating_id = created_rating["rating_id"]
    
    response = client.delete(
        f'/api/users/me/ratings/{rating_id}',
        headers=headers
    )
    assert response.status_code == 200

    rating = db_session.execute(
        select(Rating).where(Rating.id == created_rating["rating_id"])
    ).scalar_one_or_none()

    assert rating is None

def test_delete_rating_diff_user_failure(client, auth_data2, created_rating):
    headers = auth_data2['headers']
    rating_id = created_rating["rating_id"]
    
    response = client.delete(
        f'/api/users/me/ratings/{rating_id}',
        headers=headers
    )
    assert response.status_code == 403

