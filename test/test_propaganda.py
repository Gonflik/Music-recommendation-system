import pytest
from unittest.mock import patch, MagicMock
from app.services.propaganda import PropagandaDranika



def test_deduplicate_removes_duplicates():
    album1 = MagicMock()
    album1.id = 1
    album2 = MagicMock()
    album2.id = 2
    album3 = MagicMock()
    album3.id = 1

    result = PropagandaDranika.deduplicate([album1, album2, album3])

    assert len(result) == 2
    assert result[0].id == 1
    assert result[1].id == 2


def test_limit_per_artist_max_3():
    def make_album(album_id, artist_id):
        album = MagicMock()
        album.id = album_id
        album.artist.id = artist_id
        return album

    albums = [make_album(i, artist_id=1) for i in range(4)]

    result = PropagandaDranika.limit_per_artist(albums, max_per_artist=3)

    assert len(result) == 3

def test_filter_candidates_excludes_rated():
    album1 = MagicMock()
    album1.id = 1
    album1.ghost_songs_count = 5

    album2 = MagicMock()
    album2.id = 2
    album2.ghost_songs_count = 3

    excluded = {1}

    result = PropagandaDranika.filter_candidates([album1, album2], excluded)

    assert len(result) == 1
    assert result[0].id == 2


def test_filter_candidates_excludes_low_ghost_songs():
    album = MagicMock()
    album.id = 99
    album.ghost_songs_count = 1

    result = PropagandaDranika.filter_candidates([album], excluded_album_ids=set())

    assert result == []

def test_refill_with_fallback_fills_to_limit():
    def make_album(id):
        a = MagicMock()
        a.id = id
        return a

    base = [make_album(1)]
    fallback = [make_album(2), make_album(3), make_album(4)]

    result = PropagandaDranika.refill_with_fallback(base, fallback, n_albums=3)
    assert len(result) == 3

def test_refill_with_fallback_skips_duplicates():
    def make_album(id):
        a = MagicMock()
        a.id = id
        return a

    base = [make_album(1)]
    fallback = [make_album(1), make_album(2)]

    result = PropagandaDranika.refill_with_fallback(base, fallback, n_albums=2)
    assert len(result) == 2
    assert result[1].id == 2

def test_score_and_sort_candidates_orders_by_score():
    genre1 = MagicMock()
    genre1.id = 1
    genre2 = MagicMock()
    genre2.id = 2

    album_low = MagicMock()
    album_low.id = 10
    album_low.genres = [genre2]

    album_high = MagicMock()
    album_high.id = 20
    album_high.genres = [genre1]

    user_genre_map = {1: 100, 2: 5}
    result = PropagandaDranika.score_and_sort_candidates(user_genre_map, [album_low, album_high])

    assert result[0].id == 20 
    assert result[1].id == 10