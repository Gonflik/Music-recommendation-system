from model import Artist, Album, Song, Playlist, Rating, ToListen, User
from model.database import engine, init_db
from sqlalchemy.orm import Session

init_db()

with Session(engine) as session:
    artist = Artist(name="John",age=52,gender="Samolot",location="Uganda")
    session.add(artist)
    session.commit()




"""
name: Mapped[str] = mapped_column(String(100))
    description: Mapped[Optional[str]] = mapped_column(String(1200))
    age: Mapped[Optional[int]]
    gender: Mapped[Optional[str]]
    location: Mapped[str]

"""