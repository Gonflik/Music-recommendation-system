import factory
from app.model import Artist, Album, Song, Playlist, ToListen, Rating, User
from app.model.user import UserRole, GenderEnum

class UserFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = User
        sqlalchemy_session = None

    name = factory.Faker("name")
    email = factory.Faker("email")
    role = UserRole.USER
    password = factory.Faker("password")
    age = factory.Faker("random_int", min=6, max=120)
    gender= GenderEnum.MALE
    location = factory.Faker("city")
    

class ArtistFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = Artist
        sqlalchemy_session = None

    name = factory.Faker("name")
    description = factory.Faker("sentence")
    age = factory.Faker("random_int", min=6, max=120)

class SongFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = Song
        sqlalchemy_session = None

    name = factory.Faker("sentence", nb_words=3)
    length = factory.Faker("random_int", min=40, max=360)
    genre = factory.Faker("random_element", elements=["Rock", "Techno", "Metal", "Jazz", "Lo-Fi", "Indie", "Hip-hop"])
    
    album = factory.SubFactory('test.factories.AlbumFactory')
    @factory.post_generation
    def artist(self, create, extracted, **kwargs):
        if not create:
            return

        if extracted:
            self.artist.extend(extracted)
        elif self.album:
            self.artist.append(self.album.artist)
        else:
            self.artist.append(ArtistFactory())
            
    class Params:
        single = factory.Trait(
            album=None
        )

class AlbumFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = Album
        sqlalchemy_session = None

    name = factory.Faker("sentence", nb_words=3)

    artist = factory.SubFactory(ArtistFactory)
    song = factory.RelatedFactoryList('test.factories.SongFactory',
                                   factory_related_name='album', 
                                   size=1, 
                                   )

class ToListenFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = ToListen
        sqlalchemy_session = None

    note = factory.Faker("sentence")

    user = factory.SubFactory(UserFactory)
    album = factory.SubFactory(AlbumFactory)

class RatingFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = Rating
        sqlalchemy_session = None

    score = factory.Faker("random_int", min=0, max=10)
    description = factory.Faker("sentence")

    user = factory.SubFactory(UserFactory)

    album = factory.SubFactory(AlbumFactory)
    song = None

class PlaylistFactory(factory.alchemy.SQLAlchemyModelFactory):
    class Meta:
        model = Playlist
        sqlalchemy_session = None

    name = factory.Faker("sentence", nb_words=3)
    description = factory.Faker("sentence")

    @factory.post_generation
    def songs(self, create, extracted, **kwargs):
        if not create:
            return
        if extracted:
            for song in extracted:
                self.songs.append(song)
        else:
            self.songs.append(SongFactory())
            self.songs.append(SongFactory())

all_factories = [
    UserFactory,
    ArtistFactory,
    AlbumFactory,
    SongFactory,
    ToListenFactory,
    PlaylistFactory,
    RatingFactory
]