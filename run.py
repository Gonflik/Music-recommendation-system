from app import create_app, db
from dotenv import load_dotenv
from app.model import Album, Artist, Song, ToListen, User

load_dotenv()

app = create_app()

with app.app_context():
    artist = Artist(name="John Pork")
    album = Album(name="John Pork is Calling", artist_id=1)
    song = Song(name="Pork",length=123,genre="Piggy-rock", album_id=1)
    song.artist.append(artist)
    album2 = Album(name="John Pork is dead...", artist_id=1)
    song2 = Song(name="Decaying",length=5252,genre="Piggy-sad-rock", album_id=2)
    song2.artist.append(artist)
    user = User(name="asdasdsadad",email="asdasad@gmail.com", password="asjdahfa123", age=17)
    tolisten = ToListen(note="shnene", user_id=1, album_id=1)
    tolisten2 = ToListen(note="verysad", user_id=1, album_id=2)
    add_all = [album2, song2, tolisten2]
    db.session.add(artist)
    db.session.add(album)
    db.session.add(song)
    db.session.add(user)
    db.session.add(tolisten)
    db.session.add_all(add_all)
    db.session.commit()