from ..base import Base
from sqlalchemy import Table, Column, ForeignKey

tolisten_album_association = Table(
    "tolisten_album_association",
    Base.metadata,
    Column("tolisten_id", ForeignKey("tolisten.id"), primary_key=True),
    Column("album_id", ForeignKey("album.id"), primary_key=True),
)