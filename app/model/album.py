import datetime
from app.model.base import Base
from app.model.rating import Rating
from app.model.genre import Genre
from app.model.artist import Artist
from .associations.album_genre_association import album_genre_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property, validates, joinedload, selectinload
from sqlalchemy import String, ForeignKey, func, select, CheckConstraint, BigInteger, Date, DateTime
from typing import List
from app import db

class Album(Base):
    __tablename__ = "album"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(BigInteger, unique=True)
    name: Mapped[str] = mapped_column(String(500))
    length: Mapped[int | None]
    release_date: Mapped[datetime.date | None] = mapped_column(Date())
    release_type: Mapped[str | None]
    picture: Mapped[str]
    ghost_songs_count: Mapped[int | None]
    avg_rating: Mapped[float] = column_property(
        select(func.avg(Rating.score)).where(Rating.album_id == id).correlate_except(Rating).scalar_subquery()
    )
    rating_count = column_property(
        select(func.count(Rating.id))
        .where(Rating.album_id == id)
        .correlate_except(Rating)
        .scalar_subquery()
    )
    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))

    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now(), onupdate=func.now())

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
                if existing_album.length is None and item.get('length'):
                    existing_album.length = item.get('length')
                if existing_album.release_date is None and item.get('release_date'):
                    existing_album.release_date = item.get('release_date')
                if existing_album.release_type is None and item.get('release_type'):
                    existing_album.release_type = item.get('release_type')
                if existing_album.ghost_songs_count is None and item.get('ghost_songs_count'):
                    existing_album.ghost_songs_count = item.get('ghost_songs_count')
                if not existing_album.genres and item.get('genres'):
                    album_genre = Genre.write_genre(genre_data=item.get('genres'))
                    existing_album.genres.extend(album_genre)
                db.session.flush()
                result.append(existing_album)
                continue


            album_artist_id = None
            for art in artist_list:
                if item.get("artist_dzid") == art.dzid:
                    album_artist_id = art.id
            if album_artist_id is None:
                from app.model.artist import Artist
                fallback = db.session.execute(
                    select(Artist).filter_by(dzid=item.get('artist_dzid'))
                ).scalar_one_or_none()

                if not fallback:
                    fallback = Artist(
                        name=item.get('artist_name'),
                        dzid=item.get('artist_dzid'),
                        picture=item.get('artist_picture'),
                        ghost_albums_count=item.get('artist_nb_album'),
                    )
                    db.session.add(fallback)
                    db.session.flush()

                album_artist_id = fallback.id
            album_genre = Genre.write_genre(genre_data=item.get('genres'))         
            new_album = Album(
                name = item.get('name'),
                dzid = item.get('dzid'),
                length = item.get('length'),
                picture = item.get('picture'),
                ghost_songs_count = item.get('ghost_songs_count'),
                release_date = item.get('release_date'),
                release_type = item.get('release_type'),
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
    def get_album_by_id(cls, album_id, load_songs: bool = False):
        from ..services.deezer_client import DEEZNUTSAPI
        from .song import Song
        stmt = select(cls).where(cls.id==album_id).options(selectinload(cls.songs), selectinload(cls.genres), joinedload(cls.artist))
        album = db.session.scalar(stmt)
        if not load_songs:
            return album
        
        if album:
            if album.ghost_songs_count is None or len(album.songs) < album.ghost_songs_count:
                songs, albums, artists = DEEZNUTSAPI.load_songs_for_album(album.dzid, album.to_dict())

                Song.write_songs_with_artists_and_albums(songs, artists, albums)
        
                stmt = select(cls).where(cls.id==album_id).options(selectinload(cls.songs))
                album = db.session.scalar(stmt)
                return album
        return album
        
    @classmethod
    def get_by_genre_id(cls, genre_id: int, limit: int = 10):
        stmt = select(cls).join(cls.genres).where(Genre.id==genre_id).options(selectinload(cls.genres)).limit(limit) 
        return db.session.scalars(stmt).all()  
    
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
    
    @classmethod
    def get_popular(cls, limit: int, genre: str = None):
        stmt = select(cls).options(selectinload(cls.songs), selectinload(cls.genres), joinedload(cls.artist)).order_by(cls.avg_rating.desc().nulls_last()).limit(limit)
        if genre is not None:
            stmt = stmt.where(cls.genres.any(Genre.name.ilike(f'%{genre}%')))
        result = db.session.scalars(stmt).unique().all()
        return result

    def get_all(per_page: int, page: int):
        if page <= 0 or per_page <= 0:
            return None
        stmt = select(Genre).options(selectinload(Genre.albums).joinedload(Album.artist)).limit(per_page).offset((page-1) * per_page)
        genres = db.session.scalars(stmt).unique().all()
        return genres
    

    @classmethod
    def search_for_album_by_query(cls, query, per_page: int, page: int):
        from ..services.deezer_client import DEEZNUTSAPI
        stmt = select(cls).where(
            cls.name.ilike(f"%{query}%"),
        ).limit(per_page).offset((page-1) * per_page)
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
            "length": self.length if self.length else None,
            "picture": self.picture,
            "avg_rating": (float(self.avg_rating) if self.avg_rating else None),
            "rating_count": self.rating_count,
            "genres": [genre.to_dict() for genre in self.genres] if self.genres else [],
            "ghost_songs_count": self.ghost_songs_count if self.ghost_songs_count else None,
            "release_date": self.release_date.strftime("%B %d, %Y") if self.release_date else None,
            "release_type": self.release_type if self.release_type else None,
            "artist_name": self.artist.name,
            "artist_id": self.artist.id
        }
    
    