from sqlalchemy.orm import Mapped, mapped_column, relationship, validates, reconstructor
from sqlalchemy import String, CheckConstraint, select, cast, or_, BigInteger
from typing import List, Optional
from .base import Base
from .associations.artist_song_association import artist_song_association
from app import db
from ..services import DEEZNUTSAPI

class Artist(Base):
    __tablename__ = "artist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(BigInteger, unique=True)
    name: Mapped[str] = mapped_column(String(100))
    picture: Mapped[str]
    
    albums: Mapped[List["Album"]] = relationship(back_populates="artist")
    songs: Mapped[List["Song"]] = relationship(
        secondary=artist_song_association,
        back_populates="artist",
        )
    
    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_artist_name_length"),
    )

    @classmethod
    def search_for_artist_by_query(cls, query, per_page: int, page: int):
        stmt = select(cls).where(or_(
            cls.name.ilike(f"%{query}%"),
        )).limit(per_page).offset((page-1) * per_page)
        result = db.session.scalars(stmt).unique().all()
        if not result:
            artists = DEEZNUTSAPI.get_artist_by_name(query=query, per_page=per_page, page=page)
            if not artists:
                return []
            result = Artist.write_artist(artists)
            return result
        return result
    
    @classmethod
    def get_artist_by_id(cls, artist_id):
        stmt = select(cls).where(cls.id==artist_id)
        result = db.session.scalar(stmt)
        return result
    
    @classmethod
    def get_artist_by_dzid(cls, artist_dzid):
        stmt = select(cls).where(cls.dzid==artist_dzid)
        result = db.session.scalar(stmt)
        return result
    
    @classmethod
    def get_all(cls, page: int, per_page: int):
        stmt = select(cls).limit(per_page).offset((page-1) * per_page)
        result = db.session.scalars(stmt).all()
        return result

    @classmethod
    def write_artist(cls, artist_data):
        result: list[Artist] = []
        for item in artist_data:
            existing_artist = db.session.execute(
                select(cls).filter_by(dzid=item.get('dzid'))
            ).scalar_one_or_none()

            if existing_artist:
                result.append(existing_artist) 
                continue

            new_artist = Artist(
                name=item.get('name'),
                dzid=item.get('dzid'),
                picture=item.get('picture')
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
            "dzid": self.dzid,
            "name": self.name,
            "picture": self.picture
        }