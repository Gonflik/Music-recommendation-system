from ..base import Base
from sqlalchemy import Table, Column, ForeignKey

playlist_song_association = Table(
    "playlist_song_association",
    Base.metadata,
    Column("playlist_id", ForeignKey("playlist.id"), primary_key=True),
    Column("song_id", ForeignKey("song.id"), primary_key=True),
)