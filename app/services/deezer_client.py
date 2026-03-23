import deezer
from deezer import Genre

class DEEZNUTSAPI:
    "--------------------------------------WHAT WILL BE CALLED---------------------------------------------------------------------"
    def get_artist_by_name(query: str):
        with deezer.Client() as client:
            artists = client.search_artists(query=query)[:5]
            formatted_artists = DEEZNUTSAPI._format_artist(artists_data=artists)
            return formatted_artists

    def get_song_by_name(query: str):
        with deezer.Client() as client:
            songs = client.search(query=query)[:5]
            result_songs, result_albums, result_artists = DEEZNUTSAPI._format_song_with_its_artist_and_album(client=client, song_data=songs)
            return result_songs, result_albums, result_artists
        
    def get_album_by_name(query: str):
        with deezer.Client() as client:
            albums = client.search_albums(query=query)[:5]
            result_albums, result_artists = DEEZNUTSAPI._format_album_with_its_artist(album_data=albums)
            return result_albums, result_artists
    "----------------------------------------------------------------------------------------------------------------------------"


    def _format_artist(artists_data):
        result = []
        for art in artists_data:
            result.append({
                "name": art.name,
                "dzid": art.id,
                "picture": art.picture,
            })
        return result
    
    #search + return mapped data
    def _format_song_with_its_artist_and_album(client, song_data):
        formatted_songs = []
        for song in song_data:
            formatted_songs.append({
                "name": song.title,
                "dzid": song.id,
                "length": song.duration,
                "song_position": song.track_position,
                "picture": song.album.cover,
                "preview": song.preview,
                "artist_name": song.artist.name,
                "artist_dzid": song.artist.id,
                "album_name": song.album.title,
                "album_dzid": song.album.id,
            })
        
        formatted_artists = DEEZNUTSAPI.map_artists_of_songs(client, song_data)
        formatted_albums = DEEZNUTSAPI.map_albums_of_songs(client, song_data)

        return formatted_songs, formatted_albums, formatted_artists

    def _format_album_with_its_artist(album_data):
        formatted_albums = []
        for album in album_data:
            genres = []
            for genre in album.genres:
                genres.append({
                    "name": genre.name,
                    "dzid": genre.id
                })

            formatted_albums.append({
                "name": album.title,
                "dzid": album.id,
                "length": album.duration,
                "picture": album.cover,
                "genres": genres,
                "artist_name": album.artist.name,
                "artist_dzid": album.artist.id,
            })

        formatted_artists = DEEZNUTSAPI.map_artists_of_albums(album_data)
        return formatted_albums, formatted_artists


    #mappers that return parsed lists of data for a given song
    def map_artists_of_songs(client, songs: list["songs"]):
        mapped_artists = []
        artist_id_cache = []
        for song in songs:
            artist_id = song.artist.id
            if artist_id in artist_id_cache:
                continue
            artist_id_cache.append(artist_id)

            mapped_artists.append({
                "name": song.artist.name,
                "dzid": artist_id,
                "picture": song.artist.picture,
            })
        return mapped_artists
    
    def map_albums_of_songs(client, songs: list["songs"]):
        mapped_albums = []
        album_cache = {}
        for song in songs:
            album_id =  song.album.id
            if album_id in album_cache:
                continue

            album_cache[album_id] = client.get_album(album_id)
            genres = []
            for genre in album_cache[album_id].genres:
                genres.append({
                    "name": genre.name,
                    "dzid": genre.id
                })
            mapped_albums.append({
                "name": song.album.title,
                "dzid": album_id,
                "length": song.album.duration,
                "picture": song.album.cover,
                "genres": genres,
                "artist_name": album_cache[album_id].artist.name,
                "artist_dzid": album_cache[album_id].artist.id,
            })
        return mapped_albums
    
    def map_artists_of_albums(albums: list["albums"]):
        mapped_albums = []
        artist_id_cache = []
        for album in albums:
            artist_id = album.artist.id
            if artist_id in artist_id_cache:
                continue
            artist_id_cache.append(artist_id)
            mapped_albums.append({
                "name": album.artist.name,
                "dzid": artist_id,
                "picture": album.artist.picture,
            })
        return mapped_albums



# artist = DEEZNUTSAPI.get_artist_by_name(query="Death")
# for i in artist:
#     print(i)


# songe, albumi, artisto = DEEZNUTSAPI.get_song_by_name(query="Hey Jude")
# print('-----------------------------SONGS---------------------------')
# for i in songe:
#     print(i)
# print("--------------------------------------------------------------------------------")

# print('----------------------------------ALBUMS-----------------------------------------------')
# for i in albumi:
#     print(i)
# print('----------------------------------------------------------------------------------------------')

# print("------------------------------------------------ARTISTS-----------------------------------------------------------")
# for i in artisto:
#     print(i)



# albums, artists = DEEZNUTSAPI.get_album_by_name(query="The bends")
# print('--------_--------ALBUMS----------------------')
# for i in albums:
#     print(i)
# print('------------------ARTIST---------------------')
# for i in artists:
#     print(i)

