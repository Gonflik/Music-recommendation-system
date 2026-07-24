import operator
from datetime import datetime
from collections import defaultdict
from app.model.action import Action
from app.model.album import Album
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
    def deduplicate(albums):
        seen = set()
        result = []

        for album in albums:
            if album.id not in seen:
                seen.add(album.id)
                result.append(album)

        return result

    def refill_with_fallback(base, fallback, n_albums):
        seen = {a.id for a in base}
        for album in fallback:
            if len(base) >= n_albums:
                break
            if album.id not in seen:
                seen.add(album.id)
                base.append(album)
        return base

    def limit_per_artist(albums, max_per_artist: int = 3):
        artist_count = defaultdict(int)
        result = []
        for album in albums:
            artist_id = album.artist.id
            if artist_count[artist_id] < max_per_artist:
                artist_count[artist_id] += 1
                result.append(album)
        return result

    def build_user_genre_map(user_id: int) -> dict:
        from ..model.rating import Rating
        user_actions = Action.get_all_for_user(user_id)
        user_genre_map = defaultdict(int)
        excluded_album_ids = []
        for action in user_actions:
            action_reference = action.get_target()
            if not action_reference:
                continue
            
            days_old = (datetime.now() - action.created_at).days
            time_decay = 0.95 ** days_old
            weight = PropagandaDranika.ACTION_WEIGHTS[action.name] * (0.5**(action.counter - 1))
            weight *= time_decay

            if action.name == ActionName.RATE_ALBUM:
                rating_obj = Rating.get_by_album_user_id(action.reference_id, user_id)
                if not rating_obj:
                    continue
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
                if not rating_obj:
                    continue
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

        sorted_map = sorted(user_genre_map.items(), key=operator.itemgetter(1), reverse=True)[:5]
        return sorted_map, excluded_album_ids
        
    def select_canditates(user_genre_map: dict):
        if len(user_genre_map) < 3:
            popular_candidates = Album.get_popular(67)
            return popular_candidates, popular_candidates, popular_candidates
        top_genre = user_genre_map[0:1]
        secondary_genres = user_genre_map[1:-1]
        last_genre = user_genre_map[-1:]
        candidates_A = []
        candidates_B = []
        candidates_C = []

        candidates_A.extend(Album.get_by_genre_id(top_genre[0][0], limit=50))
        for key, value in secondary_genres:
            albums = Album.get_by_genre_id(key, limit=30)
            candidates_B.extend(albums)
        
        candidates_C.extend(Album.get_by_genre_id(last_genre[0][0], limit=30))
        
        return candidates_A, candidates_B, candidates_C
            
    def score_and_sort_candidates(user_genre_map: dict, albums):
        scored_results = {album: 0 for album in albums}
        for album in albums:
            for genre in album.genres:
                if genre.id in user_genre_map:
                    scored_results[album] += user_genre_map[genre.id]

        return [album for album, _ in sorted(scored_results.items(), key=lambda item: item[1], reverse=True)]

        
    def filter_candidates(candidates, excluded_album_ids):
        super_final_results = []

        for album in candidates:
            if album.id in excluded_album_ids:
                continue
            if not album.ghost_songs_count or album.ghost_songs_count < 2:
                continue
            super_final_results.append(album)
        return super_final_results


    def get_recommendations(user_id: int, n_albums: int):
        user_genre_map, excluded_ids = PropagandaDranika.build_user_genre_map(user_id)
        candidates_A, candidates_B, candidates_C = PropagandaDranika.select_canditates(user_genre_map)

        sorted_A = PropagandaDranika.score_and_sort_candidates(user_genre_map, candidates_A)
        sorted_B = PropagandaDranika.score_and_sort_candidates(user_genre_map, candidates_B)
        sorted_C = PropagandaDranika.score_and_sort_candidates(user_genre_map, candidates_C)

        final_A = PropagandaDranika.filter_candidates(sorted_A, excluded_ids)
        final_B = PropagandaDranika.filter_candidates(sorted_B, excluded_ids)
        final_C = PropagandaDranika.filter_candidates(sorted_C, excluded_ids)

        a_n = int(n_albums * 0.6)
        b_n = int(n_albums * 0.3)
        c_n = n_albums - a_n - b_n

        recommendations = final_A[:a_n] + final_B[:b_n] + final_C[:c_n]
        final_recommendations = PropagandaDranika.deduplicate(recommendations)
        final_recommendations = PropagandaDranika.limit_per_artist(final_recommendations)

        if len(final_recommendations) < n_albums:
            all_candidates = PropagandaDranika.deduplicate(final_A+final_B+final_C)
            all_candidates = PropagandaDranika.limit_per_artist(all_candidates)
            final_recommendations = PropagandaDranika.refill_with_fallback(final_recommendations, all_candidates, n_albums)


        return final_recommendations





