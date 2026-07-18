import enum
import datetime
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, joinedload, validates, selectinload
from sqlalchemy import String, ForeignKey, select, UniqueConstraint, CheckConstraint, Enum, func, DateTime
from typing import List, Optional
from app.extensions import db
from app.model import Album

class ObjectType(enum.Enum):
    SONG = "Song"
    ALBUM = "Album"
    ARTIST = "Artist"

class ToListen(Base):
    __tablename__ = "tolisten"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    note: Mapped[str] = mapped_column(String(300))
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))
    album_id: Mapped[int] = mapped_column(ForeignKey("album.id"))
    #object_type: Mapped[ObjectType] = mapped_column()

    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now(), onupdate=func.now())

    listened: Mapped[bool] = mapped_column(default=False)

    user: Mapped["User"] = relationship(back_populates="tolisten")
    album: Mapped["Album"] = relationship(back_populates="tolisten")

    __table_args__ = (
        UniqueConstraint('user_id', 'album_id', name="uq_tolisten_albumid_userid"),
    )
    #can be optimized, load_only() for artist,album
    @classmethod
    def get_all_join_album_join_artist_by_user_id(cls,user_id): 
        stmt = select(cls).where(cls.user_id== user_id).options(joinedload(cls.album).joinedload(Album.artist), joinedload(cls.album).selectinload(Album.genres))
        result = db.session.scalars(stmt).all()
        return result
    
    @classmethod
    def get_one_tolisten_by_id(cls, tolisten_id):
        stmt = select(cls).where(cls.id==tolisten_id)
        result = db.session.scalar(stmt)
        return result
    
    @classmethod
    def exists_for_user(cls, user_id, album_id):
        stmt = select(cls).filter_by(user_id=user_id, album_id=album_id)
        return db.session.scalar(stmt) is not None
    
    @classmethod
    def get_users_recent(cls, user_id):
        stmt = select(ToListen).options(joinedload(cls.album).joinedload(Album.artist), joinedload(cls.album).selectinload(Album.genres)).where(ToListen.user_id==user_id).order_by(ToListen.created_at.desc()).limit(5)
        result = db.session.scalars(stmt)
        return result

    @classmethod
    def count_user_tolisten(cls, user_id):
        stmt = select(func.count(ToListen.id)).where(ToListen.user_id==user_id)
        return db.session.scalar(stmt)

    #you need to pass user_id before when creating a ToListen, so it works fine
    @validates('album_id')
    def validate_album_id(self, key, album_id):
        stmt = select(ToListen).where(
            ToListen.user_id==self.user_id,
            ToListen.album_id==album_id)
        existing = db.session.scalar(stmt)
        if existing:
            raise ValueError("This album is already in your list!")
        return album_id
    
    @validates('note')
    def validate_note_length(self, key, note):
        if len(note) > 300:
            raise ValueError("Note is too long(max 300 chars)")
        return note


    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()


    def to_dict(self):
        return {
            "id": self.id,
            "note": self.note,
            "listened": self.listened,
            "created_at": self.created_at,
            "Album": self.album.to_dict()
        }