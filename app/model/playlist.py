from .base import Base
from .associations.playlist_song_association import playlist_song_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import String, ForeignKey, CheckConstraint, select
from typing import List, Optional
from app import db

class Playlist(Base):
    __tablename__ = "playlist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(120))
    description: Mapped[str] = mapped_column(String(200))
    #genre?? кабута шляпа
    
    songs: Mapped[List["Song"]] = relationship(
        secondary=playlist_song_association,
        back_populates="playlists",
        )
    
    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 1:
            raise ValueError("Name too short(min 1 char)")
        return name
    
    @classmethod
    def search_for_playlist_by_query(cls, query):
        stmt = select(cls).where(cls.name.ilike(f"%{query}%")).limit(10)
        result = db.session.scalars(stmt).all()
        return result
    
    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
        }
