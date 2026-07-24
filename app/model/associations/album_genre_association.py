from ..base import Base
from sqlalchemy import Table, Column, ForeignKey, UniqueConstraint

album_genre_association = Table(
    "album_genre_association",
    Base.metadata,
    Column("album_id", ForeignKey("album.id"), primary_key=True),
    Column("genre_id", ForeignKey("genre.id"), primary_key=True),
)