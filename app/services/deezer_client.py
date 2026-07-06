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

            genres = [{"name": g.name, "dzid": g.id} for g in album.genres]
            fresh_album_dict = {
                **album_dict,
                "ghost_songs_count": album.nb_tracks,
                "length": album.duration,
                "release_date": album.release_date,
                "release_type": album.record_type,
                "genres": genres,
            }

            results_songs, results_albums, results_artists = DEEZNUTSAPI._format_song_with_its_artist_and_album(client=client, song_data=song_objects, no_album=fresh_album_dict, include_track_position=True)
            return results_songs, [results_albums], results_artists
   
    def load_top_artists_songs(artist_dzid: int):
        with deezer.Client() as client:
            artist = client.get_artist(artist_dzid)
            top_songs = artist.get_top()
            result_top_songs, result_albums, result_artists = DEEZNUTSAPI._format_song_with_its_artist_and_album(client=client, song_data=top_songs, known_artist=artist)
            return result_top_songs, result_albums, result_artists

    def load_all_artists_albums(artist_dzid: int):
        with deezer.Client() as client:
            artist = client.get_artist(artist_dzid)
            albums = artist.get_albums()
            result_albums, result_artists = DEEZNUTSAPI._format_album_with_its_artist(album_data=albums)
            return result_albums, result_artists

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
                "ghost_albums_count": art.nb_album,
            })
        return result
    
    #search + return mapped data
    def _format_song_with_its_artist_and_album(client, song_data, no_album: dict = {}, include_track_position: bool = False, known_artist = None):
        formatted_songs = []
        for song in song_data:
            formatted_songs.append({
                "name": song.title,
                "dzid": song.id,   
                "length": song.duration,
                "song_position": song.track_position if include_track_position else None,                                           
                "picture": song.album.cover,
                "preview": song.preview,
                "artist_name": song.artist.name,
                "artist_dzid": song.artist.id,
                "album_name": song.album.title,
                "album_dzid": song.album.id,
            })
        
        formatted_artists = DEEZNUTSAPI.map_artists_of_songs(client, song_data, known_artist=known_artist)
        formatted_albums = no_album
        if not no_album:
            formatted_albums = DEEZNUTSAPI.map_albums_of_songs(client, song_data, skip_full_fetch=(known_artist is not None))
        
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
                "release_date": album.release_date,
                "release_type": album.record_type,
                "artist_name": album.artist.name,
                "artist_dzid": album.artist.id,
            })

        formatted_artists = DEEZNUTSAPI.map_artists_of_albums(album_data)
        return formatted_albums, formatted_artists


    #mappers that return parsed lists of data for a given song
    def map_artists_of_songs(client, songs: list["songs"], known_artist = None):
        mapped_artists = []
        artist_id_cache = []

        if known_artist:
            artist_id_cache.append(known_artist.id)
            mapped_artists.append({
                "name": known_artist.name,
                "dzid": known_artist.id,
                "picture": known_artist.picture,
                "ghost_albums_count": known_artist.nb_album,
            })


        for song in songs:
            artist_id = song.artist.id
            if artist_id in artist_id_cache:
                continue
            artist_id_cache.append(artist_id)

            mapped_artists.append({
                "name": song.artist.name,
                "dzid": artist_id,
                "picture": song.artist.picture,
                "ghost_albums_count": song.artist.nb_album
            })
        return mapped_artists
    
    def map_albums_of_songs(client, songs: list["songs"], skip_full_fetch: bool = False):
            mapped_albums = []
            album_cache = set()
            for song in songs:
                album_id = song.album.id
                if album_id in album_cache:
                    continue
                album_cache.add(album_id)

                if skip_full_fetch:
                    mapped_albums.append({
                        "name": song.album.title,
                        "dzid": song.album.id,
                        "length": None,
                        "picture": song.album.cover,
                        "genres": [],
                        "ghost_songs_count": None,
                        "release_date": None,       # fixed
                        "release_type": None,       # fixed
                        "artist_name": song.artist.name,
                        "artist_dzid": song.artist.id,
                        "artist_picture": song.artist.picture,
                        "artist_nb_album": song.artist.nb_album,
                    })
                else:
                    album = client.get_album(album_id)
                    genres = [{"name": g.name, "dzid": g.id} for g in album.genres]
                    mapped_albums.append({
                        "name": album.title,
                        "dzid": album.id,
                        "length": album.duration,
                        "picture": album.cover,
                        "genres": genres,
                        "ghost_songs_count": album.nb_tracks,
                        "release_date": album.release_date,
                        "release_type": album.record_type,
                        "artist_name": album.artist.name,
                        "artist_dzid": album.artist.id,
                        "artist_picture": album.artist.picture,
                        "artist_nb_album": album.artist.nb_album,
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
                "ghost_albums_count": album.artist.nb_album,
            })
        return mapped_artists

