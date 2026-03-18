import pytest
from app.model import User
from ..factories import SongFactory, AlbumFactory, PlaylistFactory, RatingFactory, ArtistFactory, UserFactory

def test_create_valid_song(db_session):
    artist = ArtistFactory()
    song = SongFactory(artist=[artist])
    db_session.flush()
    assert song is not None

def test_song_relationship(db_session):
    artist = ArtistFactory()
    album = AlbumFactory(artist=artist)
    song = SongFactory(artist=[artist], album=album)
    playlist = PlaylistFactory(songs=[song])
    rating = RatingFactory(song=song,user=UserFactory())
    db_session.flush()
    assert len(song.artist) > 0 
    assert song.album is not None
    assert song.playlists is not None
    assert song.ratings is not None

def test_create_song_single(db_session):
    artist = ArtistFactory()
    song = SongFactory(album=None, artist=[artist])
    assert song is not None
    assert song.album is None

def test_song_no_artist(db_session):
    with pytest.raises(ValueError):
        song = SongFactory(artist=[])
        db_session.flush()

def test_song_name_len_constraint(db_session):
    artist = ArtistFactory()
    with pytest.raises(ValueError):
        song = SongFactory(name='', artist=artist)
        db_session.flush()
    with pytest.raises(ValueError):
        song = SongFactory(name='asdashfhhfhhfhffffffffffffffffffffffffffffffffffffffffffffff', artist=artist)
        db_session.flush()
def test_song_length_constraint(db_session):
    with pytest.raises(ValueError):
        song = SongFactory(length=15)
    
    