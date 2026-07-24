import pytest


def test_tolisten_add_entry(client, auth_data, created_rating):
    headers = auth_data["headers"]
    album_id = created_rating["album_id"]
    req = client.post("/api/tolisten", headers=headers, json={"note": "cool_album", "album_id": album_id})

    assert req.status_code == 201


def test_tolisten_add_entry_duplicate(client, auth_data, created_rating):
    headers = auth_data["headers"]
    album_id = created_rating["album_id"]
    req = client.post("/api/tolisten", headers=headers, json={"note": "cool_album", "album_id": album_id})

    assert req.status_code == 201

    req2 = client.post("/api/tolisten", headers=headers, json={"note": "cool_album67", "album_id": album_id})

    assert req2.status_code == 409

def test_tolisten_update_entry(client, auth_data, created_rating):
    headers = auth_data["headers"]
    album_id = created_rating["album_id"]
    req = client.post("/api/tolisten", headers=headers, json={"note": "cool_album", "album_id": album_id})

    assert req.status_code == 201
    tolisten_id = req.get_json()["tolisten_id"]

    req2 = client.patch(f"/api/tolisten/{tolisten_id}", headers=headers, json={"note": "veri fine", "listened": True})

    assert req2.status_code == 200

def test_tolisten_delete_entry(client, auth_data, created_rating):
    headers = auth_data["headers"]
    album_id = created_rating["album_id"]
    req = client.post("/api/tolisten", headers=headers, json={"note": "cool_album", "album_id": album_id})

    assert req.status_code == 201
    tolisten_id = req.get_json()["tolisten_id"]

    req2 = client.delete(f"/api/tolisten/{tolisten_id}", headers=headers)

    assert req2.status_code == 200

def test_tolisten_delete_diff_user_entry(client, auth_data, created_rating, auth_data2):
    headers = auth_data["headers"]
    headers2 = auth_data2["headers"]
    album_id = created_rating["album_id"]
    req = client.post("/api/tolisten", headers=headers, json={"note": "cool_album", "album_id": album_id})

    assert req.status_code == 201
    tolisten_id = req.get_json()["tolisten_id"]

    req2 = client.delete(f"/api/tolisten/{tolisten_id}", headers=headers2)

    assert req2.status_code == 403


