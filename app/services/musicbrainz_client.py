import musicbrainzngs


class MBAPI:
    user_agent = musicbrainzngs.set_useragent("MRS", 1.0, "danylobucharov@gmail.com")

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
        result = musicbrainzngs.search_artists(query=search_query, limit=3)
        artist_list = result.get('artist-list')
        if not artist_list:
            return False

        formatted_artists = []
        for item in artist_list:
            alias_list = item.get('alias-list', [])
            aliases = set()

            original_name = item.get("name", "No-name")
            foreign_name = None
            for dic in alias_list:
                if val := dic.get("alias"): aliases.add(val)
                if s_name := dic.get("sort-name"): aliases.add(s_name)
                if dic.get("locale") == "en" and dic.get("primary"):
                    foreign_name = val
                
            aliases.discard(original_name)
            if foreign_name:
                aliases.discard(foreign_name)

            formatted_artists.append({
                "name": original_name,
                "foreign_name": foreign_name,
                "mbid": item.get("id"),
                "description": item.get("disambiguation", "empty"),
                "aliases": list(aliases)
            })
        return formatted_artists
    
    def get_song_by_name(search_query: str):
        lucene_query = (
            f'recording:"{search_query}" AND status:official'
        )
        result = musicbrainzngs.search_recordings(query=search_query, limit=5)
        recordings = result.get('recording-list')
        if not recordings:
            return f"Song not found!(empty list)"
        
        formatted_songs = []
        for item in recordings:
            all_credits = item.get('artist-credit', [])
            primary_artist_id = all_credits[0].get('artist', {}).get('id') if all_credits else None

            formatted_songs.append({
                "name": item.get('title'),
                "mbid": item.get('id'),
                "length": int(item.get("length", 0)) // 1000,
                "artist_name": item.get('artist-credit-phrase'),
                "artist_mbid": primary_artist_id,
                "album": item.get('release-list', [{}])[0].get('title', "Single"),
            })

        return formatted_songs
        
    def get_album_by_name(search_query: str):
        pass




    def get_artist_by_id(artist_mbid):
        pass
    


try:
    artist = MBAPI.get_artist_by_name(search_query="Пошлая Молли")
    for i in artist:
        print(i)
except ValueError as e:
    print({"Error": e})

"""try:
    songs = MBAPI.get_artist_by_name(search_query="I never told you what i do for a living")
    for i in songs:
        print(i)
except Exception as e:
    print({"Error": e})"""