import musicbrainzngs
from .mappers import SongMapper, ArtistMapper



class MBAPI:
    musicbrainzngs.set_useragent("MRS", 1.0, "danylobucharov@gmail.com")

    """def get_artist_by_name(search_query, album):
        result = musicbrainzngs.search_artists(query=search_query, limit=1)
        print(result)
        print("---------------------------------------------------------------------------")
        artist_search = result['artist-list']
        print(artist_search)
        print("---------------------------------------------------------------------------")
        description  = artist_search[0].get("disambiguation") if artist_search[0].get("disambiguation") else "empty"
        print(description)
        print("---------------------------------------------------------------------------")
        artist_id = artist_search[0]["id"]
        print(artist_id)
        print("---------------------------------------------------------------------------")
        result = musicbrainzngs.get_artist_by_id(artist_id, includes=['release-groups'], release_type=['album', 'ep'])
        for release_group in result["artist"]["release-group-list"]:
            print("{title} ({type})".format(title=release_group["title"],
                                    type=release_group["type"]))
        print("---------------------------------------------------------------------------")
        print(result["artist"]["release-group-list"][0])
        print("------------------------------ALBUMS--------------------------------------")
        album = musicbrainzngs.search_release_groups(releasegroup=album, primarytype=['album'], limit=1)
        for group in album['release-group-list']:
            print(f"Title: {group['title']}")
            print(f"ID: {group['id']}")
            print(f"Type: {group.get('primary-type', 'N/A')}")"""

    def get_artist_by_name(search_query: str):
        request = musicbrainzngs.search_artists(query=search_query, limit=3)

        artist_list = request.get('artist-list', [])
        parsed_data = ArtistMapper.map_artist(artist_list)


        return parsed_data
        
    
    def get_song_by_name_with_artists(search_query: str) -> tuple[list[dict], list[dict]]:
        request = musicbrainzngs.search_recordings(query=search_query, limit=3)
        recordings = request.get('recording-list')

        parsed_song, parsed_artist = SongMapper.map_song_with_artist(recordings)
        return parsed_song, parsed_artist
        
        
    def get_album_by_name(search_query: str):
        pass




    def get_artist_by_id(artist_mbid):
        pass
    





# try:
#     artist = MBAPI.get_artist_by_name(search_query="Zwyntar")
#     for i in artist:
#         print("---------------------------------------------------------------------------")
#         print(i)
#         print("---------------------------------------------------------------------------")
# except ValueError as e:
#     print({"Error": e})

# try:
    # songs, artists = MBAPI.get_song_by_name_with_artists(search_query="Miles Davis")
    # for x in songs:
    #     print("---------------------------------------------------------------------------")
    #     print(x)
    #     print("---------------------------------------------------------------------------")
    # print("--------------------ARTISTS------------------------")
    # for y in artists:
    #     print("---------------------------------------------------------------------------")
    #     print(y)
    #     print("---------------------------------------------------------------------------")
# except Exception as e:
#     print({"Error": e})