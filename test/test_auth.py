import pytest

from sqlalchemy import select
from app.model import User

def test_registration_success(client, mock_user_data, db_session):
    register_response = client.post('/api/users', json=mock_user_data)
    assert register_response.status_code == 201
    user_id = register_response.get_json().get('id')

    user = db_session.scalar(select(User).where(User.id==user_id))
    assert user is not None
    assert user.id == user_id


def test_registration_duplicate_failure(client, mock_user_data):
    register_response = client.post('/api/users', json=mock_user_data)

    register_response = client.post('/api/users', json=mock_user_data)
    assert register_response.status_code == 409

def test_registration_miss_req_fields(client):
    register_response = client.post('/api/users', json={
        "name": "abobik",
        "email": "abobik@gmail.com"
    })
    assert register_response.status_code == 400


def test_login_success(client, mock_user_data):
    register_response = client.post('/api/users', json=mock_user_data)

    login_response = client.post('/api/users/login', json=mock_user_data)
    
    assert login_response.status_code == 200
    data = login_response.get_json()
    assert "tokens" in data
    assert "access" in data["tokens"]
    assert "refresh" in data["tokens"]


def test_login_failure(client, mock_user_data):
    register_response = client.post('/api/users', json=mock_user_data)

    mock_user_data["password"]  = "poopoo"

    login_response = client.post('/api/users/login', json=mock_user_data)
    
    assert login_response.status_code == 401


def test_refresh_token_success(client, auth_data):
    res = client.get('/refresh', headers={"Authorization": f"Bearer {auth_data['refresh']}"})

    assert res.status_code == 200
    data = res.get_json()
    assert "access_token" in data

def test_refresh_invalid_token(client):
    res = client.get('/refresh', headers={"Authorization": f"Bearer {'thisisnotvalidtoken'}"})

    assert res.status_code == 401


