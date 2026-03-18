import musicbrainzngs

class ArtistMapper:
    def map_artist(data) -> list[dict]:
        if not data:
            return []
        
        formatted_artists = []
        for item in data:
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