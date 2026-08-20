from app import create_app, db
from dotenv import load_dotenv
from app.model import Album, Artist, Song, ToListen, User, Genre
from app.services import PropagandaDranika

app = create_app()

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)