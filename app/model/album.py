from .base import Base
from .song import Song
from .rating import Rating
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property, validates, joinedload
from sqlalchemy import String, ForeignKey, func, select, CheckConstraint
from typing import List
from app import db

class Album(Base):
    __tablename__ = "album"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100))
    length: Mapped[int] = column_property(
        select(func.sum(Song.length)).where(Song.album_id == id).correlate_except(Song).scalar_subquery()
    )
    avg_rating: Mapped[float] = column_property(
        select(func.avg(Rating.score)).where(Rating.song_id == id).correlate_except(Rating).scalar_subquery()
    )
    
    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))

    artist: Mapped["Artist"] = relationship(back_populates="albums")
    songs: Mapped[List["Song"]] = relationship(back_populates="album")
    ratings: Mapped[List["Rating"]] = relationship(back_populates="album")
    tolisten: Mapped[List["ToListen"]] = relationship(back_populates="album")

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_album_name_length"),
    )

    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 1:
            raise ValueError("Album name cant be empty(min 1 char)")
        return name
    
    @classmethod
    def get_album_by_id(cls, album_id):
        stmt = select(cls).where(cls.id==album_id)
        album = db.session.scalar(stmt)
        return album
    
    @classmethod
    def get_album_by_name(cls, name):
        stmt = select(cls).where(cls.name.ilike(name))
        album = db.session.scalar(stmt)
        return album
    
    @classmethod
    def search_for_album_by_query(cls, query):
        stmt = select(cls).options(joinedload(cls.artist)).where(cls.name.ilike(f"%{query}%")).limit(10)
        result = db.session.scalars(stmt).all()
        return result
    
    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "length": self.length,
            "artist_name": self.artist.name,
        }
