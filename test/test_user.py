import pytest




def test_user_profile(client, auth_data):
    headers = auth_data["headers"]
    user_id = auth_data["user_id"]
    req = client.get(f"/api/users/{user_id}", headers=headers)

    data = req.get_json()

    assert req.status_code == 200
    assert "name" in data
    assert "email" in data

def test_user_profile_404(client, auth_data):
    headers = auth_data["headers"]
    req = client.get(f"/api/users/100", headers=headers)

    assert req.status_code == 404


def test_user_profile_update(client, auth_data):
    headers = auth_data["headers"]
    user_id = auth_data["user_id"]

    req = client.patch(f"/api/users/{user_id}", headers=headers, json={"bio": "newbiotypebeat", "age": 52})

    data = req.get_json()

    assert req.status_code == 200
    assert data["User"]["bio"] == "newbiotypebeat"
    assert data["User"]["age"] == 52

def test_user_profile_update_403(client, auth_data, auth_data2):
    user_id = auth_data["user_id"]
    headers = auth_data2["headers"]

    req = client.patch(f"/api/users/{user_id}", headers=headers, json={"bio": "newbiotypebeat", "age": 52})

    assert req.status_code == 403

def test_user_delete_success(client, auth_data):
    user_id = auth_data["user_id"]
    headers = auth_data["headers"]

    req = client.delete(f"/api/users/{user_id}", headers=headers, json={"password": "danylo12345"})

    assert req.status_code == 200

def test_user_delete_403(client, auth_data, auth_data2):
    user_id = auth_data["user_id"]
    headers = auth_data2["headers"]

    req = client.delete(f"/api/users/{user_id}", headers=headers, json={"password": "danylo12345"})

    assert req.status_code == 403



    