from .base import Base
from .song import Song
from .rating import Rating
from .associations.tolisten_album_association import tolisten_album_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property
from sqlalchemy import String, ForeignKey, func, select
from typing import List, Optional

class Album(Base):
    __tablename__ = "album"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100))
    length: Mapped[int] = column_property(
        select(func.sum(Song.length)).where(Song.album_id == id).correlate_except(Song).scalar_subquery()
    )
    avg_rating = column_property(select(func.avg(Rating.score).where(Rating.song_id == id)).correlate_except(Rating).scalar_subquery())
    
    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))

    artist: Mapped["Artist"] = relationship(back_populates="albums")
    songs: Mapped[List["Songs"]] = relationship(back_populates="album")
    ratings: Mapped[List["Rating"]] = relationship(back_populates="album")
    tolisten: Mapped[List["ToListen"]] = relationship(
        secondary=tolisten_album_association,
        back_populates="albums",
    )