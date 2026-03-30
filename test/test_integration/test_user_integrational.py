import pytest
import json

@pytest.mark.integration
def test_create_user_success(client, mock_user_data):
    response = client.post('/users', data=json.dumps(mock_user_data), 
                           headers={"Content-Type": "application/json"})
    assert response.status_code == 201

@pytest.mark.integration
def test_create_user_failure(client):
    register_response = client.post('/users', data=json.dumps({
        "name": "",
        "age": 0,
        "email": "",
        "password": "123"
    }), headers={"Content-Type": "application/json"})
    assert register_response.status_code == 400

@pytest.mark.integration
def test_user_login_success(client, mock_user_data):
    response = client.post('/users', data=json.dumps(mock_user_data), 
                           headers={"Content-Type": "application/json"})
    assert response.status_code == 201

    response = client.post('/users/login', data=json.dumps(mock_user_data), headers={"Content-Type": "application/json"})
    assert response.status_code == 200

@pytest.mark.integration
def test_user_login_failure(client, mock_user_data):
    response = client.post('/users', data=json.dumps(mock_user_data), 
                           headers={"Content-Type": "application/json"})
    assert response.status_code == 201

    response = client.post('/users/login', data=json.dumps({"email": "danylo@gmail.com",
                                                           "password": "bebebe"}), 
                                                           headers={"Content-Type": "application/json"})
    assert response.status_code == 401
    

@pytest.mark.integration
def test_user_profile_success(client, mock_user_data ,auth_data):
    #pytest runs auth_headers which creates a user
    headers = auth_data['headers']
    user_id = auth_data['user_id']
    response = client.get(f'/users/{user_id}', headers=headers)
    assert response.status_code == 200


@pytest.mark.integration
def test_user_put_success(client, mock_user_data, auth_data):
    headers = auth_data['headers']
    headers['Content-Type'] = 'application/json'
    user_id = auth_data['user_id']
    response = client.put(f'/users/{user_id}',data=json.dumps({"name": "Bobik",
                                                               "age": 33,
                                                               "gender": "male",
                                                               "location": "Mount Hua"}), headers=headers)
    assert response.status_code == 200

@pytest.mark.integration
def test_user_put_failure(client, mock_user_data, auth_data):
    headers = auth_data['headers']
    headers['Content-Type'] = 'application/json'
    user_id = auth_data['user_id']
    response = client.put(f'/users/{user_id}',data=json.dumps({"name": "Bobik",
                                                               "gender": "male",
                                                               "location": ""}), headers=headers)
    assert response.status_code == 400

@pytest.mark.integration
def test_user_logout(client, mock_user_data, auth_data):
    refresh_token = auth_data['refresh']

    response = client.get('users/logout', headers={"Authorization": f"Bearer {refresh_token}"})

    assert response.status_code == 200

