import musicbrainzngs
from .artist_mapper import ArtistMapper

class SongMapper:
    def map_song_with_artist(data) -> tuple[list[dict], list[dict]]:
        if not data:
            return [], []
        
        formatted_songs = []
        artist_ids = set()


        for item in data:
            all_credits = item.get('artist-credit', [])
            primary_artist = all_credits[0].get('artist', {}) if all_credits else {}
            p_id = primary_artist.get('id')

            if not p_id:
                continue
            artist_ids.add(p_id)

            formatted_songs.append({
                "name": item.get('title'),
                "mbid": item.get('id'),
                "length": int(item.get("length", 0)) // 1000,
                "artist_name": item.get('artist-credit-phrase'),
                "artist_mbid": p_id,
                "album": item.get('release-list', [{}])[0].get('title', "Single"),
            })

        formatted_artists = []
        if artist_ids:
            batch_query = " OR ".join([f"arid:{aid}" for aid in artist_ids])
            artist_results = musicbrainzngs.search_artists(query=batch_query)
            
            formatted_artists = ArtistMapper.map_artist(data=artist_results.get('artist-list', []))

        return formatted_songs, formatted_artists