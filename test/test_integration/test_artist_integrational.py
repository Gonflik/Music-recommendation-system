import pytest
    
@pytest.mark.integration
def test_api_artist_success(client, mock_deezer_api_response_artist, auth_data):
    headers = auth_data['headers']
    response = client.get('/search?q=MASS OF THE FERMENTING DREGS', headers=headers)
    assert response.status_code == 200

    data = response.get_json()
    assert data["Artists"][0]["name"] == "mass of the fermenting dregs"
    assert data["Artists"][0]["dzid"] == 27

@pytest.mark.integration
def test_api_artist_empty_response(client, mock_deezer_api_response_artist_empty, auth_data):
    headers = auth_data['headers']
    response = client.get('/search?q=MASS OF THE FERMENTING DREGS', headers=headers)
    assert response.status_code == 404







