from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship, joinedload
from sqlalchemy import String, ForeignKey, select
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

    @classmethod
    def get_album_join_tolisten_by_user_id(cls,user_id): 
        stmt = select(cls).where(cls.user_id== user_id).options(joinedload(cls.album).joinedload(Album.artist))
        result = db.session.scalars(stmt).all()
        return result