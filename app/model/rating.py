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
    def get_all_ratings_album_artist(cls, smthg, smthg1):
        pass

    @classmethod
    def get_one_rating_by_id(cls, rating_id):
        stmt = select(cls).where(cls.id==rating_id)
        result = db.session.scalar(stmt)
        return result

    @validates('score')
    def validate_score(self, key, score):
        if score > 10 or score < 0:
            raise ValueError("Score is out of scope!(0-10)")
        return score

    @validates('song_id')
    def validate_song_id(self, key, song_id):
        stmt = select(Rating).where(Rating.user_id==self.user_id, Rating.song_id==song_id)
        existing = db.session.scalar(stmt)
        if existing:
            raise ValueError("You've already rated this song!")
        return song_id
    
    @validates('album_id')
    def validate_album_id(self, key, album_id):
        stmt = select(Rating).where(Rating.user_id==self.user_id, Rating.album_id==album_id)
        existing = db.session.scalar(stmt)
        if existing:
            raise ValueError("You've already rated this album!")
        return album_id

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

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
            "description": f"{self.description[:100]}...",
            f"{target.__class__.name}": {
                "id": target.id,
                "name": target.name,
                "length": target.length, #btw for every length of album a query is run
                "artist_name": artist_names
            },
        }

    @classmethod
    def rate_album(cls, artist_id, album_id):
        #check if artist exists
        #check if album exists
        #proceed to create rating, maybe some other checks
        pass

    @classmethod
    def rate_song(cls, artist_id, song_id):
        #check if artist exists
        #check if song exists
        #proceed to create rating, maybe some other checks
        pass
