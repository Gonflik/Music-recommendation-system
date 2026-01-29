from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Text, CheckConstraint, ForeignKey
from typing import List, Optional
from .base import Base

class Rating(Base):
    __tablename__ = "rating"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    score: Mapped[int] 
    description: Mapped[Optional[str]] = mapped_column(Text)

    album_id: Mapped[int] = mapped_column(ForeignKey="album.id")
    song_id: Mapped[int] = mapped_column(ForeignKey="song.id")

    album: Mapped["Album"] = relationship(back_populates="ratings")
    song: Mapped["Song"] = relationship(back_populates="ratings")
    
    __table_args__ = (
        CheckConstraint(
                "score BETWEEN 0 and 10",
                name="ck_rating_score_range",
            ),
        )
    user: Mapped["User"] = relationship(back_populates="ratings")
    song: Mapped["Song"] = relationship(back_populates="ratings")
    album: Mapped["Album"] = relationship(back_populates="ratings")
