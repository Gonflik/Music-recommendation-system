from ..base import Base
from sqlalchemy import Table, Column, ForeignKey

artist_song_association = Table(
    "artist_song_association",
    Base.metadata,
    Column("artist_id", ForeignKey("artist.id"), primary_key=True),
    Column("song_id", ForeignKey("song.id"), primary_key=True),
)