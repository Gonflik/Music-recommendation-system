from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, joinedload, validates
from sqlalchemy import String, ForeignKey, select, UniqueConstraint, CheckConstraint
from typing import List, Optional
from app.extensions import db
from app.model import Album

class ToListen(Base):
    __tablename__ = "tolisten"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    note: Mapped[str] = mapped_column(String(300))
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))
    album_id: Mapped[int] = mapped_column(ForeignKey("album.id"))

    user: Mapped["User"] = relationship(back_populates="tolisten")
    album: Mapped["Album"] = relationship(back_populates="tolisten")

    __table_args__ = (
        UniqueConstraint('user_id', 'album_id', name="uq_tolisten_albumid_userid"),
    )

    @classmethod
    def get_album_join_tolisten_join_artist_by_user_id(cls,user_id): 
        stmt = select(cls).where(cls.user_id== user_id).options(joinedload(cls.album).joinedload(Album.artist))
        result = db.session.scalars(stmt).all()
        return result
    
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