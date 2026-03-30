from .base import Base
from .rating import Rating #!!!
from .artist import Artist
from .album import Album
from .associations.playlist_song_association import playlist_song_association
from .associations.artist_song_association import artist_song_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property, validates, joinedload, Session
from sqlalchemy import String, ForeignKey, func, select, CheckConstraint, event, BigInteger
from typing import List, Optional
from app import db
from ..services import DEEZNUTSAPI

class Song(Base):
    __tablename__ = "song"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(BigInteger, unique=True)
    name: Mapped[str] = mapped_column(String(100))
    length: Mapped[int]
    song_position: Mapped[int]
    picture: Mapped[str]
    preview: Mapped[str]
    avg_rating = column_property(
        select(func.avg(Rating.score)).where(Rating.song_id == id).correlate_except(Rating).scalar_subquery()
    )
    
    album_id: Mapped[int | None] = mapped_column(ForeignKey("album.id"))

    artist: Mapped[List["Artist"]] = relationship(
        secondary=artist_song_association,
        back_populates="songs",
    )
    album: Mapped["Album"] = relationship(back_populates="songs")
    playlists: Mapped[List["Playlist"]] = relationship(
        secondary=playlist_song_association,
        back_populates="songs",
    )
    ratings: Mapped[List["Rating"]] = relationship(back_populates="song")

    __table_args__ = (
        CheckConstraint("LENGTH(name) > 0", name="ck_name_length"),
        CheckConstraint("length > 30", name="ck_length_value"), 
    )

    @validates('name')
    def validate_name(self, key, name):
        if len(name) < 1:
            raise ValueError("Name is too short!(min 1 char)")
        return name
    
    @validates('length')
    def validate_length(self,key, length):
        if length < 30:
            raise ValueError("Song too short(min length 30s)")
        return length

    @event.listens_for(Session, "before_flush")
    def check_for_artist(session, flush_context, instances):
        for obj in session.new | session.dirty:
            if isinstance(obj, Song):
                if not obj.artist:
                    raise ValueError(f"Song with id:{obj.id}. Must have an artist!")
    
    @classmethod
    def get_song_by_id(cls, song_id):
        stmt = select(cls).where(cls.id==song_id)
        song = db.session.scalar(stmt)
        return song

    @classmethod
    def search_for_song_by_query(cls, query):
        stmt = select(cls).options(joinedload(cls.artist)).where(cls.name.ilike(f"%{query}%")).limit(10)
        result = db.session.scalars(stmt).unique().all()
        if not result:
            songs, albums, artists = DEEZNUTSAPI.get_song_by_name(query=query) 
            if not songs:
                return []
            result = Song.write_songs_with_artists_and_albums(song_data=songs, artist_data=artists, album_data=albums)
            return result
        return result
    
    @classmethod
    def write_songs_with_artists_and_albums(cls, song_data, artist_data, album_data):
        result: list[Song] = []
        artists = Artist.write_artist(artist_data)
        print("ARTISTS WRITTEN:", [artist.to_dict() for artist in artists])
        albums = Album.write_albums(album_data=album_data, artist_list=artists)
        print("ALBUMS WRITTEN:", [album.to_dict() for album in albums])
        for item in song_data:
        
            existing_song = db.session.execute(
                select(cls).filter_by(dzid=item.get('dzid'))
            ).scalar_one_or_none()
            
            if existing_song:
                result.append(existing_song)
                continue

            song_album_id = None
            for album in albums:
                if item.get("album_dzid") == album.dzid:
                    song_album_id = album.id

            
            new_song = Song(
                name = item.get('name'),
                dzid = item.get('dzid'),
                length = item.get('length'),
                song_position = item.get('song_position'),
                picture = item.get('picture'),
                preview = item.get('preview'),
                album_id = song_album_id,
            )
            artist = None
            for art in artists:
                if art.dzid == item.get('artist_dzid'):
                    artist = art

            print("MATCH SONG ITEM:", item)
            print("MATCHED ARTIST:", artist)
            print("MATCHED ALBUM ID:", song_album_id)
            new_song.artist.append(artist)
            
            result.append(new_song)
            db.session.add(new_song)
            db.session.flush()
        db.session.commit()
        return result


    
    def to_dict(self):
        return {
            "id": self.id,
            "dzid": self.dzid,
            "name": self.name,
            "length": self.length,
            "song_position": self.song_position,
            "picture": self.picture,
            "preview": self.preview,
            "artist_name": self.artist[0].name,
            "artist_id": self.artist[0].id,
            "album_name": self.album.name if self.album else None,
            "album_id": self.album.id if self.album else None
        }