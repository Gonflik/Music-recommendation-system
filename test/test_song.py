import pytest
from app.model import User
from .factories import SongFactory

def test_create_song_and_relationship(db_session):
    song = SongFactory()
    assert song is not None
    assert len(song.artist) > 0 
    assert song.album is not None

def test_song_album_same_artist(db_session):
    song = SongFactory()
    assert song.artist == [song.album.artist]
