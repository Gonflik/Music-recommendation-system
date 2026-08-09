# ratestuff.fm | music-recommendation-system

![homepage](/app/static/images/indexpage.png)

A full-stack music rating and recommendation web app. Rate albums and songs,
build a ToListen list, and get personalized recommendations based on your taste.

Live demo: (coming soon)

---

## Features

- **Rate** albums(1-10) and songs(1-5) with optional reviews
- **ToListen** list — save albums you want to check out later with personal notes
- **Recommendations** — PropagandaDranika engine builds a genre preference map
  from your listening history and ratings, then scores and ranks candidates
- **Search** albums, artists, and songs powered by the Deezer API
- **Public profiles** — view any user's ratings and activity

---

## Tech Stack

**Backend**
- Python / Flask
- SQLAlchemy 2.x + PostgreSQL
- Flask-JWT-Extended (access + refresh tokens)
- Redis — preview URL caching + search result caching, artist album/top track caching
- Deezer API via deezer-python

**Frontend**
- Vanilla JS (ES modules)
- Jinja2 templating
- Hand-drawn / sketchy aesthetic (Indie Flower font, notebook-style cards)

**Infrastructure**
- Docker + Docker Compose
- pytest + coverage (75% coverage)

---

## Running locally

```bash
git clone https://github.com/yourname/Music-recommendation-system
cd Music-recommendation-system
docker compose up
```

App runs at `http://localhost:5000`

---

## Running tests

```bash
# start test db
docker compose --profile test up -d db_test

# run suite
pytest

# with coverage
coverage run -m pytest && coverage report
```

---

## Architecture

- REST API (`/api/...`) + server-rendered pages
- JWT stored in localStorage, sent as Bearer token
- `PropagandaDranika` recommendation engine — weights user actions
  (views, ratings, saves) with time decay and genre scoring
- Redis caches Deezer preview URLs and search results to avoid
  redundant API calls and DB queries. Search cache keys include
  query, page, and per_page — user-specific data (in_tolisten)
  is computed fresh per request on top of cached results.
  Artist pages cache the full album list and top tracks per artist.

---

## Diagrams

- [Entity diagram](https://www.figma.com/board/N0pxGvjtGdsVxDgebz4rsX/Music-database?node-id=0-1)
- [Sequence diagram](https://www.figma.com/board/uapBxZakk8wbqJZ62jd1eA/MRS-Sequence-diagram?node-id=0-1)
- [Database schema](/sql_dump.sql)
