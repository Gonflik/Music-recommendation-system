from .base import Base

from app import db
from.associations.album_genre_association import album_genre_association
from sqlalchemy.orm import Mapped, mapped_column, relationship, selectinload, joinedload
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

    def get_by_id(genre_id):
        from .album import Album
        from .artist import Artist
        stmt = select(Genre).where(Genre.id==genre_id).options(selectinload(Genre.albums).joinedload(Album.artist))
        genres = db.session.scalar(stmt)
        return genres

    def get_all(per_page: int, page: int):
        from .album import Album
        from .artist import Artist
        if page <= 0 or per_page <= 0:
            return None
        stmt = select(Genre).options(selectinload(Genre.albums).joinedload(Album.artist)).limit(per_page).offset((page-1) * per_page)
        genres = db.session.scalars(stmt).unique().all()
        return genres

    def to_dict(self):
        return {
            "name": self.name,
            "id": self.id,
            "dzid": self.dzid,
            "Albums": [alb.id for alb in self.albums],
        }