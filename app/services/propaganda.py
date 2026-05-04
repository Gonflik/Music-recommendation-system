import operator
from collections import defaultdict
from app.model.action import Action
from app.model.album import Album
from app.model.recommendation import Recommendation
from app.model.action import ActionName, ReferenceClassName
from sqlalchemy import select
from app.extensions import db

class PropagandaDranika:
    ACTION_WEIGHTS = {
        ActionName.ALBUM_SHOW: 5,
        ActionName.ARTIST_SHOW: 3,
        ActionName.ADD_TO_LISTEN: 7,
        ActionName.RATE_ALBUM: 10,
        ActionName.RATE_SONG: 10,
    }


    def build_user_genre_map(user_id: int) -> dict:
        from ..model.rating import Rating
        user_actions = Action.get_all_for_user(user_id)
        babagaga = [act.to_dict() for act in user_actions]
        for i in babagaga:
            print(i)
        user_genre_map = defaultdict(int)
        excluded_album_ids = []
        for action in user_actions:
            action_reference = action.get_target()
            if not action_reference:
                continue

            weight = PropagandaDranika.ACTION_WEIGHTS[action.name] * (0.5**(action.counter - 1)) #добавити decay, тобто 1 дає 100% score, dali 70% i t.d.
            if action.name == ActionName.RATE_ALBUM:
                rating_obj = Rating.get_by_album_user_id(action.reference_id, user_id)
                if rating_obj.score <= 5:
                    excluded_album_ids.append(action_reference.id)
                    for g in action_reference.genres:
                        user_genre_map[g.id] += ((rating_obj.score * 3.75) - 13.75)
                else:
                    excluded_album_ids.append(action_reference.id)
                    for g in action_reference.genres:
                        user_genre_map[g.id] += ((rating_obj.score * 2.25) - 7.5)

            elif action.name == ActionName.RATE_SONG:
                rating_obj = Rating.get_by_song_user_id(action.reference_id, user_id)
                if rating_obj.score <= 5:
                    excluded_album_ids.append(action_reference.album.id)
                    for g in action_reference.album.genres:
                        user_genre_map[g.id] += ((rating_obj.score * 3.75) - 13.75)
                else:
                    excluded_album_ids.append(action_reference.album.id)
                    for g in action_reference.album.genres:
                        user_genre_map[g.id] += ((rating_obj.score * 2.25) - 7.5)

            elif action.reference_name == ReferenceClassName.ALBUM:
                if action.name != ActionName.ALBUM_SHOW:
                    excluded_album_ids.append(action_reference.id)
                if action.name == ActionName.ALBUM_SHOW and action.counter >= 4:
                    excluded_album_ids.append(action_reference.id)
                for g in action_reference.genres:
                    user_genre_map[g.id] += weight

            elif action.reference_name == ReferenceClassName.ARTIST:
                for album in action_reference.albums[:3]:
                    for g in album.genres:
                        user_genre_map[g.id] += weight

            elif action.reference_name == ReferenceClassName.SONG:
                excluded_album_ids.append(action_reference.album.id)
                for g in action_reference.album.genres:
                    user_genre_map[g.id] += weight

        sorted_map = dict(sorted(user_genre_map.items(), key=operator.itemgetter(1), reverse=True)[:5]) #mb po inshomu
        print("DEBUG -----------------------------------------------------------------------------------", sorted_map)
        for key,value in sorted_map.items():
            print(f"Genre: {key} - {value}")
        return sorted_map, excluded_album_ids
        
    def select_canditates(user_genre_map: dict):
        

        candidates = []
        for key, value in user_genre_map.items():
            albums = Album.get_by_genre_id(key, limit=15)
            print(f"-----as-d-ad-ass-da-d-as-sd-sa-a-d-d--sa- !!!!!{albums}")
            candidates.extend(albums)
        return candidates
            
    def score_and_sort_candidates(user_genre_map: dict, albums):
        scored_results = defaultdict(int)
        for album in albums:
            for genre in album.genres:
                if genre.id in user_genre_map:
                    scored_results[album] += user_genre_map[genre.id]
        
        return list(sorted(scored_results.items(), key=lambda item: item[1], reverse=True))

        
    def filter_candidates(candidates, excluded_album_ids):
        super_final_results = []
        i = 0
        for album, score in candidates:
            if i == 5:
                break
            if album.id in excluded_album_ids:
                continue
            if album.ghost_songs_count < 2:
                continue
            super_final_results.append(album)
            i += 1
        return super_final_results


    def get_recommendations(user_id: int):
        user_genre_map, excluded_ids = PropagandaDranika.build_user_genre_map(user_id)
        print(f"ADADHSADASHDHADH X----------{excluded_ids}")
        candidates = PropagandaDranika.select_canditates(user_genre_map)

        almost_final_candidates = PropagandaDranika.score_and_sort_candidates(user_genre_map, candidates)

        final_candidates = PropagandaDranika.filter_candidates(almost_final_candidates, excluded_ids)

        return final_candidates


#what to filter before giving out the recommendation
"""
album.release_type == "album"
album.ghost_songs_count > 1
album.id not in interacted_album_ids
"""



