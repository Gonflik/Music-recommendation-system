from .base import Base
from .associations.playlist_song_association import playlist_song_association
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from typing import List, Optional

class Playlist(Base):
    __tablename__ = "playlist"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(120))
    description: Mapped[str] = mapped_column(String(200))
    #genre?? кабута шляпа
    
    songs: Mapped[List["Song"]] = relationship(
        secondary=playlist_song_association,
        back_populates="playlists",
        )
