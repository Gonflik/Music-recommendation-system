from .base import Base
from .associations.tolisten_album_association import tolisten_album_association
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from typing import List, Optional

class Album(Base):
    __tablename__ = "album"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100))
    length = 0 #похідний
    genre: Mapped[str] #має бути ауто-детект хз

    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))

    artist: Mapped["Artist"] = relationship(back_populates="albums")
    songs: Mapped[List["Songs"]] = relationship(back_populates="album")
    ratings: Mapped[List["Rating"]] = relationship(back_populates="album")
    tolisten: Mapped[List["ToListen"]] = relationship(
        secondary=tolisten_album_association,
        back_populates="albums",
    )