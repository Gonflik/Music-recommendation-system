from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import String, CheckConstraint
from typing import List, Optional
from .base import Base
from .associations.artist_song_association import artist_song_association

class Artist(Base):
    __tablename__ = "artist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100))
    description: Mapped[Optional[str]] = mapped_column(String(1200))
    age: Mapped[Optional[int]]
    gender: Mapped[Optional[str]]
    location: Mapped[Optional[str]]

    albums: Mapped[List["Album"]] = relationship(back_populates="artist")
    songs: Mapped[List["Song"]] = relationship(
        secondary=artist_song_association,
        back_populates="artist",
        )
    
    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_artist_name_length"),
    )

    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 1:
            raise ValueError("Name too short(min 1 char)")
        return name