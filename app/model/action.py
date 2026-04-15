import enum
import datetime
from app import db
from sqlalchemy import Enum, DateTime, func, Integer, ForeignKey
from .base import Base
from app.model import Artist, Album, Song
from sqlalchemy.orm import Mapped, mapped_column, relationship, selectinload, joinedload
from typing import List
from sqlalchemy import select

class ActionName(str, enum.Enum):
    ALBUM_SHOW = "album_show"
    ARTIST_SHOW = "artist_show" #non-existent yet
    ADD_TO_LISTEN = "add_to_listen" #make polymorph
    RATE_ALBUM = "rate_album"
    #RATE SONG coming...

class ReferenceClassName(str, enum.Enum):
    ALBUM = "album"
    SONG = "song"
    ARTIST = "artist"

class Action(Base):
    __tablename__ = "action"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[ActionName] = mapped_column(
        Enum(ActionName, name="action_name_enum"),
        nullable=False
    )
    reference_name: Mapped[ReferenceClassName] = mapped_column(
        Enum(ReferenceClassName, name="user_action_object_enum")
    )
    reference_id: Mapped[int]
    counter: Mapped[int] = mapped_column(Integer, default=1)
    
    timestamp: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())

    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))
    user: Mapped["User"] = relationship(back_populates="actions")

    def get_target(self) -> object:
        if self.reference_name == "album":
            return Album.get_album_by_id(self.reference_id)
        if self.reference_name == "artist":
            return Artist.get_artist_by_id(self.reference_id)
        if self.reference_name == "song":
            return Song.get_song_by_id(self.reference_id)
        
    @classmethod
    def create_or_increment(cls, name: ActionName, user_id, reference_id, reference_name: ReferenceClassName):
        stmt = select(cls).where(cls.user_id==user_id, cls.reference_id==reference_id, cls.name==name, cls.reference_name==reference_name)
        existing_action = db.session.scalar(stmt)
        if existing_action:
            existing_action.counter += 1
            db.session.commit()
            return

        new_action = Action(name=name, reference_name=reference_name, reference_id=reference_id, user_id=user_id)
        new_action.save()

        return "pepe"

    def save(self):
        db.session.add(self)
        db.session.commit()
