from sqlalchemy.orm import (Mapped, mapped_column, relationship, 
                            validates, joinedload, load_only, 
                            selectinload, reconstructor)
from sqlalchemy import String, Text, CheckConstraint, ForeignKey, select, UniqueConstraint
from typing import List, Optional
from app import db
from .base import Base

class Rating(Base):
    __tablename__ = "rating"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    score: Mapped[int] 
    description: Mapped[Optional[str]] = mapped_column(Text)

    album_id: Mapped[int | None] = mapped_column(ForeignKey("album.id"))
    song_id: Mapped[int | None] = mapped_column(ForeignKey("song.id"))
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))
    
    album: Mapped["Album"] = relationship(back_populates="ratings")
    song: Mapped["Song"] = relationship(back_populates="ratings")
    user: Mapped["User"] = relationship(back_populates="ratings")

    @reconstructor
    def init_on_load(self):
        self.errors = []

    def __init__(self, **kw):
        self.errors = []
        super().__init__(**kw)

    __table_args__ = (
        CheckConstraint(
                "score BETWEEN 0 and 10",
                name="ck_rating_score_range",
            ),
        UniqueConstraint('user_id', 'song_id', name='uq_user_song_rating'),
        UniqueConstraint('user_id', 'album_id', name='uq_user_album_rating'),
        )
    
    @classmethod
    def get_all_ratings_by_user_id(cls, user_id, page: int, per_page: int):
        from .song import Song
        from .album import Album
        from .artist import Artist
        stmt = select(cls).where(cls.user_id==user_id).options(
            joinedload(cls.song).load_only(Song.id,Song.name,Song.length).selectinload(Song.artist).load_only(Artist.name),
            joinedload(cls.album).load_only(Album.id,Album.name,Album.length).joinedload(Album.artist).load_only(Artist.name),
        ).limit(per_page).offset((page-1) * per_page)
        result = db.session.scalars(stmt).unique().all()
        return result
    
    @classmethod
    def get_all_ratings_by_album_id(cls, album_id):
        from .song import Song
        from .album import Album
        from .artist import Artist
        stmt = select(cls).where(cls.album_id==album_id).options(
            joinedload(cls.song).selectinload(Song.artist),
            joinedload(cls.album).joinedload(Album.artist),
            joinedload(cls.album).selectinload(Album.genres),
        )
        result = db.session.scalars(stmt).unique().all()
        return result
    
    @classmethod
    def get_all_ratings_by_song_id(cls, song_id):
        from .song import Song
        from .album import Album
        from .artist import Artist
        stmt = select(cls).where(cls.song_id==song_id).options(
            joinedload(cls.song).selectinload(Song.artist),
            joinedload(cls.album).joinedload(Album.artist),
        )
        result = db.session.scalars(stmt).unique().all()
        return result

    @classmethod
    def get_one_rating_by_id(cls, rating_id):
        from .song import Song
        from .album import Album
        from .artist import Artist
        stmt = select(cls).where(cls.id==rating_id).options(
            joinedload(cls.song).selectinload(Song.artist),
            joinedload(cls.album).joinedload(Album.artist),
            joinedload(cls.album).selectinload(Album.genres),
        )
        result = db.session.scalar(stmt)
        return result

    @classmethod
    def get_by_album_user_id(cls, album_id, user_id):
        from .album import Album
        stmt = select(cls).where(cls.album_id==album_id, cls.user_id==user_id).options(joinedload(cls.album).joinedload(Album.artist))
        result = db.session.scalar(stmt)
        return result

    @classmethod
    def get_by_song_user_id(cls, song_id, user_id):
        from .song import Song
        stmt = select(cls).where(cls.song_id==song_id, cls.user_id==user_id).options(joinedload(cls.song).joinedload(Song.artist))
        result = db.session.scalar(stmt)
        return result

    @validates('score')
    def validate_score(self, key, score):
        if score > 10 or score < 0:
            self.errors.append(f"Score: {score} is out of scope!(0-10)")
        return score

    @validates('description')
    def validate_description(self, key, description):
        if description is not None:
            if len(description) > 1200:
                self.errors.append(f"Description is too long({len(description)}/1200)") 
        return description
    #user_id needs to be passed before song_id
    @validates('song_id')
    def validate_song_id(self, key, song_id):
        stmt = select(Rating).where(Rating.user_id==self.user_id, Rating.song_id==song_id)
        existing = db.session.scalar(stmt)
        if existing:
            self.errors.append(f"You've already rated this song!(song_id:{song_id})")
        return song_id
    
    #user_id needs to be passed before album_id
    @validates('album_id')
    def validate_album_id(self, key, album_id):
        stmt = select(Rating).where(Rating.user_id==self.user_id, Rating.album_id==album_id)
        existing = db.session.scalar(stmt)
        if existing:
            self.errors.append(f"You've already rated this album!(album_id:{album_id})")
        return album_id

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
        return True, {"message" : "Rating deleted successfully!", "code": 200}

    #should only be used after the def get_rating functions
    def to_dict(self):
        target = self.album if self.album else self.song

        if self.album:
            artist_names = [target.artist.name]
        else:
            artist_names = [artist.name for artist in target.artist]

        return {
            "id": self.id,
            "score": self.score,
            "description": f"{self.description[:100]}..." if self.description else "5 centimeters per second",
            f"{target.__class__.__name__}": target.to_dict(),
        }

    @classmethod
    def rate_album(cls, artist_id, album_id, data, user_id):
        from .album import Album
        from .artist import Artist
        artist = Artist.get_artist_by_id(artist_id)
        if artist is None:
            return None, {"error": "Artist not found!", "code": 404}
        
        album = Album.get_album_by_id(album_id)
        if album is None:
            return None, {"error": "Album not found!", "code": 404}
        
        score = data.get('score')
        description = data.get('description', '5 centimeters per second')

        new_rating = Rating(
            user_id=user_id,
            album_id=album_id,
            score=score,
            description=description
        )

        if len(new_rating.errors) > 0:
            return None, {"error": new_rating.errors, "code": 400}
        
        new_rating.save()

        return new_rating, None


    @classmethod
    def rate_song(cls, artist_id, song_id, data, user_id):
        from .song import Song
        from .artist import Artist
        artist = Artist.get_artist_by_id(artist_id)
        if artist is None:
            return None, {"error": "Artist not found!", "code": 404}
        
        song = Song.get_song_by_id(song_id)
        if song is None:
            return None, {"error": "Song not found!", "code": 404}
        
        score = data.get('score')
        description = data.get('description', '5 centimeters per second')

        new_rating = Rating(
            user_id=user_id,
            song_id=song_id,
            score=score,
            description=description
        )

        if len(new_rating.errors) > 0:
            return None, {"error": new_rating.errors, "code": 400}
        
        new_rating.save()

        return new_rating, None
    
    def update(self, data):
        self.score = data.get('score')
        self.description = data.get('description')

        if len(self.errors) > 0:
            return False, {"error": self.errors, "code": 400}
        
        self.save()
        return True, None