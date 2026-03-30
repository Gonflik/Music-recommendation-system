from .base import Base
from app import db
from.associations.album_genre_association import album_genre_association
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import List
from sqlalchemy import select 


class Genre(Base):
    __tablename__ = "genre"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    dzid: Mapped[int] = mapped_column(unique=True)
    name: Mapped[str]

    albums: Mapped[List["Album"]] = relationship(
        secondary=album_genre_association,
        back_populates="genres"
    )

    @classmethod
    def write_genre(cls, genre_data) -> Genre:
        result: list[Genre] = []
        for item in genre_data:
            genre_dzid = item.get('dzid')
            existing_genre = db.session.execute(
                select(cls).filter_by(dzid=genre_dzid)
            ).scalar_one_or_none()

            if existing_genre:
                result.append(existing_genre)
                continue

            new_genre = Genre(
                name = item.get('name'),
                dzid = genre_dzid,
            )
            result.append(new_genre)
        return result


    def to_dict(self):
        return {"name": self.name, "dzid": self.dzid, "id": self.id}