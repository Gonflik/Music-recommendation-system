import deezer
from deezer import Genre

class DEEZNUTSAPI:
    
    "--------------------------------------WHAT WILL BE CALLED---------------------------------------------------------------------"
    def get_artist_by_name(query: str, per_page: int, page: int) -> list[dict]:
        with deezer.Client() as client:
            artists = client.search_artists(query=query)
            paginated_artists = DEEZNUTSAPI.paginate(artists, per_page, page) #additional calls may be issued here!
            formatted_artists = DEEZNUTSAPI._format_artist(artists_data=paginated_artists)
            return formatted_artists

    def get_song_by_name(query: str, per_page: int, page: int) -> tuple[list[dict], list[dict], list[dict]]:
        with deezer.Client() as client:
            songs = client.search(query=query)
            paginated_songs = DEEZNUTSAPI.paginate(songs, per_page, page)
            result_songs, result_albums, result_artists = DEEZNUTSAPI._format_song_with_its_artist_and_album(client=client, song_data=paginated_songs)
            return result_songs, result_albums, result_artists
        
    def get_album_by_name(query: str, per_page: int, page: int) -> tuple[list[dict], list[dict]]:
        with deezer.Client() as client:
            albums = client.search_albums(query=query)
            paginated_albums = DEEZNUTSAPI.paginate(albums, per_page, page)
            result_albums, result_artists = DEEZNUTSAPI._format_album_with_its_artist(album_data=paginated_albums)
            return result_albums, result_artists
        
    def load_songs_for_album(album_dzid: int, album_dict: dict) -> list[dict]:
        with deezer.Client() as client:
            album = client.get_album(album_id=album_dzid)
            song_objects = album.get_tracks()
            results_songs, results_albums, results_artists = DEEZNUTSAPI._format_song_with_its_artist_and_album(client=client, song_data=song_objects, no_album=album_dict)
            return results_songs, [results_albums], results_artists

    "----------------------------------------------------------------------------------------------------------------------------"
    def paginate(items, per_page: int, page: int):
        start = (page - 1) * per_page
        end = start + per_page
        return items[start:end]

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
    def _format_song_with_its_artist_and_album(client, song_data, no_album: dict = {}):
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
        formatted_albums = no_album
        if not no_album:
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
                "ghost_songs_count": album.nb_tracks,
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
            album_id = song.album.id
            if album_id in album_cache:
                continue
            
            album = client.get_album(album_id)
            album_cache[album_id] = album

            genres = []
            for genre in album.genres:
                genres.append({
                    "name": genre.name,
                    "dzid": genre.id
                })
            mapped_albums.append({
                "name": album.title,
                "dzid": album.id,
                "length": album.duration,
                "picture": album.cover,
                "genres": genres,
                "ghost_songs_count": album.nb_tracks,
                "artist_name": album.artist.name,
                "artist_dzid": album.artist.id,
            })
        return mapped_albums
    
    def map_artists_of_albums(albums: list["albums"]):
        mapped_artists = []
        artist_id_cache = []
        for album in albums:
            artist_id = album.artist.id
            if artist_id in artist_id_cache:
                continue
            artist_id_cache.append(artist_id)
            mapped_artists.append({
                "name": album.artist.name,
                "dzid": artist_id,
                "picture": album.artist.picture,
            })
        return mapped_artists



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



# albums, artists = DEEZNUTSAPI.get_album_by_name(query="In rainbows")
# print('--------_--------ALBUMS----------------------')
# for i in albums:
#     print(i)
# print('------------------ARTIST---------------------')
# for i in artists:
#     print(i)

