from .base import Base
from .rating import Rating #!!!
from .artist import Artist
from .associations.playlist_song_association import playlist_song_association
from .associations.artist_song_association import artist_song_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, column_property, validates, joinedload, Session
from sqlalchemy import String, ForeignKey, func, select, CheckConstraint, event
from typing import List, Optional
from app import db
from ..services import MBAPI

class Song(Base):
    __tablename__ = "song"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    mbid: Mapped[str] = mapped_column(unique=True)
    name: Mapped[str] = mapped_column(String(50))
    length: Mapped[int]
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
            songs, artists = MBAPI.get_song_by_name_with_artists(query)
            if not songs:
                return False
            result = Song.write_songs_with_artists(songs,artists)
            return result
        return result
    
    @classmethod
    def write_songs_with_artists(cls, song_data, artist_data):
        result: list[Song] = []
        artists = Artist.write_artist(artist_data)

        for item in song_data:
            print(f"DEBUG: Processing SONG item -> {item}")
            mbid = item['mbid']
        
            # existing_artist = db.session.execute(
            #     select(cls).filter_by(mbid=mbid)
            # ).scalar_one_or_none()
            
            # if existing_artist:
            #     result.append(existing_artist)
            #     continue
            
            new_song = Song(
                name=item.get('name'),
                mbid=mbid,
                length=item.get('length'),
                #album_id=tre dopisat shob she album davalo
            )
            artist = None
            for art in artists:
                if art.mbid==item.get('artist_mbid'):
                    artist = art
            new_song.artist.append(artist)
            
            result.append(new_song)
            db.session.add(new_song)
            db.session.flush()
        db.session.commit()
        return result


    
    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "length": self.length,
            "artist_name": self.artist[0].name,
            #dopisat self.album, handling None + yak minat search_for_song_by_query
        }