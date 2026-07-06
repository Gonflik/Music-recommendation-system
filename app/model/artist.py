import datetime
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates, reconstructor
from sqlalchemy import String, CheckConstraint, select, cast, or_, BigInteger, DateTime, func
from typing import List, Optional
from .base import Base
from .associations.artist_song_association import artist_song_association

from app import db


class Artist(Base):
    __tablename__ = "artist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(BigInteger, unique=True)
    name: Mapped[str] = mapped_column(String(100))
    picture: Mapped[str]
    ghost_albums_count: Mapped[int]
    
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now(), onupdate=func.now())

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
        from ..services.deezer_client import DEEZNUTSAPI
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
        artist = db.session.scalar(stmt)
        if not artist:
            return []
        return artist
    
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
    #------------------------------------------------------------------------------------------------------------------------
    def get_top_songs_deezer(self):
        from .song import Song
        from app.services.deezer_client import DEEZNUTSAPI
        top_songs, albums, artists = DEEZNUTSAPI.load_top_artists_songs(self.dzid)
        if not top_songs:
            return []
        
        result = Song.write_songs_with_artists_and_albums(song_data=top_songs, artist_data=artists, album_data=albums)
        return result

    def get_all_albums_deezer(self):
        from .album import Album
        from app.services.deezer_client import DEEZNUTSAPI
        albums, artists = DEEZNUTSAPI.load_all_artists_albums(self.dzid)
        if not albums:
            return []
        artist_list = Artist.write_artist(artists)
        result = Album.write_albums(albums, artist_list)
        return result
    #------------------------------------------------------------------------------------------------------------------------
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
                picture=item.get('picture'),
                ghost_albums_count=item.get('ghost_albums_count')
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
            "picture": self.picture,
            "ghost_albums_count": self.ghost_albums_count,
        }