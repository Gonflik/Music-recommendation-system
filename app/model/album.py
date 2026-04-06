from .base import Base
from .rating import Rating
from .artist import Artist
from .genre import Genre
from .associations.album_genre_association import album_genre_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property, validates, joinedload, selectinload
from sqlalchemy import String, ForeignKey, func, select, CheckConstraint, BigInteger
from typing import List
from app import db
from ..services import DEEZNUTSAPI

class Album(Base):
    __tablename__ = "album"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(BigInteger, unique=True)
    name: Mapped[str] = mapped_column(String(200))
    length: Mapped[int]
    #release_date: Mapped[int]
    picture: Mapped[str]
    ghost_songs_count: Mapped[int]
    avg_rating: Mapped[float] = column_property(
        select(func.avg(Rating.score)).where(Rating.album_id == id).correlate_except(Rating).scalar_subquery()
    )
    
    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))

    genres: Mapped[List["Genre"]] = relationship(
        secondary=album_genre_association,
        back_populates="albums"
    ) 
    artist: Mapped["Artist"] = relationship(back_populates="albums")
    songs: Mapped[List["Song"]] = relationship(back_populates="album")
    ratings: Mapped[List["Rating"]] = relationship(back_populates="album")
    tolisten: Mapped[List["ToListen"]] = relationship(back_populates="album")

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_album_name_length"),
    )

    @classmethod
    def write_albums(cls, album_data, artist_list):
        result: list[Album] = []
        for item in album_data:
            existing_album = db.session.execute(
                select(cls).filter_by(dzid=item.get('dzid'))
            ).scalar_one_or_none()

            if existing_album:
                result.append(existing_album)
                continue


            album_artist_id = None
            for art in artist_list:
                if item.get("artist_dzid") == art.dzid:
                    album_artist_id = art.id

            album_genre = Genre.write_genre(genre_data=item.get('genres'))         

            new_album = Album(
                name = item.get('name'),
                dzid = item.get('dzid'),
                length = item.get('length'),
                picture = item.get('picture'),
                ghost_songs_count = item.get('ghost_songs_count'),
                artist_id = album_artist_id,
            )
            new_album.genres.extend(album_genre)
            result.append(new_album)
            db.session.add(new_album)
            db.session.flush()
        db.session.commit()
        return result

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
    def get_album_by_dzid(cls, album_dzid):
        stmt = select(cls).where(cls.dzid==album_dzid)
        result = db.session.scalar(stmt)
        return result

    @classmethod
    def get_album_by_name(cls, name):
        stmt = select(cls).where(cls.name.ilike(name))
        album = db.session.scalar(stmt)
        return album
    
    def get_all(per_page: int, page: int):
        if page <= 0 or per_page <= 0:
            return None
        stmt = select(Genre).options(selectinload(Genre.albums).joinedload(Album.artist)).limit(per_page).offset((page-1) * per_page)
        genres = db.session.scalars(stmt).all()
        return genres
    
    @classmethod
    def search_for_album_by_query(cls, query, per_page: int, page: int):
        stmt = select(cls).where(
            cls.name.ilike(f"%{query}%"),
        ).limit(per_page).offset((page-1) * per_page) #injection REVIEW
        result = db.session.scalars(stmt).all()
        if not result:
            albums, artists = DEEZNUTSAPI.get_album_by_name(query=query, per_page=per_page, page=page)
            if not albums:
                return []
            artist_list = Artist.write_artist(artists)
            result = Album.write_albums(albums, artist_list)
            return result
        return result
    
    def to_dict(self):
        return {
            "id": self.id,
            "dzid": self.dzid,
            "name": self.name,
            "length": self.length,
            "picture": self.picture,
            "genres": [genre.to_dict() for genre in self.genres] if self.genres else [],
            "artist_name": self.artist.name,
            "artist_id": self.artist.id
        }
