from sqlalchemy.orm import Mapped, mapped_column, relationship, validates, reconstructor
from sqlalchemy import String, CheckConstraint, select, cast, or_
from sqlalchemy.dialects.postgresql import ARRAY
from typing import List, Optional
from .base import Base
from .associations.artist_song_association import artist_song_association
from app import db
from ..services import MBAPI

class Artist(Base):
    __tablename__ = "artist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    mbid: Mapped[str] = mapped_column(unique=True)
    name: Mapped[str] = mapped_column(String(100))
    foreign_name: Mapped[str | None]
    aliases: Mapped[list[str] | None] = mapped_column(ARRAY(String))
    description: Mapped[str | None] = mapped_column(String(1200))
    age: Mapped[int | None]
    gender: Mapped[str | None]
    location: Mapped[str | None]

    albums: Mapped[List["Album"]] = relationship(back_populates="artist")
    songs: Mapped[List["Song"]] = relationship(
        secondary=artist_song_association,
        back_populates="artist",
        )
    
    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_artist_name_length"),
    )

    @classmethod
    def search_for_artist_by_query(cls, query):
        stmt = select(cls).where(or_(
            cls.name.ilike(f"%{query}%"),
            cls.foreign_name.ilike(f"%{query}%"),
            cast(cls.aliases, String).ilike(f"%{query}%") 
        )).limit(10) #injection REVIEW
        result = db.session.scalars(stmt).all()
        if not result:
            artists = MBAPI.get_artist_by_name(query)
            if not artists:
                return False
            result = Artist.write_artist(artists)
            return result
        return result
    
    @classmethod
    def get_artist_by_id(cls, artist_id):
        stmt = select(cls).where(cls.id==artist_id)
        result = db.session.scalar(stmt)
        return result

    @classmethod
    def write_artist(cls, artist_data):
        result: list[Artist] = []
        
        for item in artist_data:
            print(f"DEBUG: Processing item -> {item}")
            mbid = item['mbid']
        
            existing_artist = db.session.execute(
                select(cls).filter_by(mbid=mbid)
            ).scalar_one_or_none()

            if existing_artist:
                result.append(existing_artist)
                continue
            
            new_artist = Artist(
                name=item['name'],
                foreign_name=item['foreign_name'],
                mbid=mbid,
                description=item['description'],
                aliases=item['aliases']
            )
            
            result.append(new_artist)
            db.session.add(new_artist)
            db.session.flush()
        db.session.commit()
        return result

    def save(self):
        db.session.add(self)
        db.session.commit()

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "foreign_name": self.foreign_name,
            "description": self.description if self.description else "empty",
            "aliases": self.aliases[:3]
        }