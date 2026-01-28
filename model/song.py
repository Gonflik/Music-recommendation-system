from .base import Base
from .associations.playlist_song_association import playlist_song_association
from .associations.artist_song_association import artist_song_association
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from typing import List, Optional

class Song(Base):
    __tablename__ = "song"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(50))
    length: Mapped[int]
    #avg_rating = похідний атрибут, буде виконуватись запит коли тре його
    genre: Mapped[str] #має бути аутодетект хзхз

    artist_id: Mapped[int] = mapped_column(ForeignKey("artist.id"))
    album_id: Mapped[int] = mapped_column(ForeignKey("album.id"))

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