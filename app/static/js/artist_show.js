import { updateNav } from './navbar.js';
import { apiFetch } from './api.js';
import { makePlayBtn } from './player.js';
import { openToListenPopup } from './tolistenPopup.js';


updateNav();

if (!localStorage.getItem('access_token')) {
  window.location.href = '/users';
}

// ── Burger ────────────────────────────────────────
(function () {
  var btn      = document.getElementById('burgerBtn');
  var nav      = document.getElementById('mobileNav');
  var backdrop = document.getElementById('navBackdrop');
  var closeBtn = document.getElementById('navClose');
  function openNav()  { btn.classList.add('open');    nav.classList.add('open');    document.body.style.overflow = 'hidden'; }
  function closeNav() { btn.classList.remove('open'); nav.classList.remove('open'); document.body.style.overflow = ''; }
  btn.addEventListener('click', () => nav.classList.contains('open') ? closeNav() : openNav());
  closeBtn.addEventListener('click', closeNav);
  backdrop.addEventListener('click', closeNav);
})();

// ── Helpers ───────────────────────────────────────
function escHtml(str) {
  return String(str ?? '')
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function fmtLength(seconds) {
  if (!seconds) return '';
  const m = Math.floor(seconds / 60);
  const s = String(seconds % 60).padStart(2, '0');
  return `${m}:${s}`;
}

// ── Toast ─────────────────────────────────────────
function showToast(msg, ok = true) {
  const t = document.getElementById('toast');
  if (!t) return;
  t.textContent = msg;
  t.className = 'toast ' + (ok ? 'toast-ok' : 'toast-err') + ' toast-show';
  clearTimeout(t._timer);
  t._timer = setTimeout(() => t.classList.remove('toast-show'), 2800);
}

// ── Render hero ───────────────────────────────────
function renderHero(artist, albumCount = 0, genres = []) {
  const photo = document.getElementById('artistPhoto');
  photo.src = artist.picture || '/static/images/radioheadicon.png';
  photo.onerror = () => { photo.src = '/static/images/radioheadicon.png'; };
  photo.alt = artist.name;

  document.getElementById('artistName').textContent = artist.name;

  document.getElementById('backBtn').addEventListener('click', () => {
    if (document.referrer) history.back();
    else window.location.href = '/explore';
  });

  const stats = document.getElementById('artistStats');
  stats.innerHTML = '';

  if (albumCount) {
    const countEl = document.createElement('p');
    countEl.className = 'artist-hero-albumcount';
    countEl.textContent = `${albumCount} albums`;
    stats.appendChild(countEl);
  }

  if (genres.length) {
    const genreEl = document.createElement('p');
    genreEl.className = 'artist-hero-genres';
    genreEl.textContent = genres.map(g => g.name).join(', ');
    stats.appendChild(genreEl);
  }

  document.title = `${artist.name} – ratestuff.fm`;
}

// ── Render top tracks ─────────────────────────────
const TRACKS_PREVIEW = 5;

function renderBatch(items, list) {
  items.forEach((track) => {
    const globalIdx = list.querySelectorAll('.top-track-row').length;
    const row = document.createElement('div');
    row.className = 'top-track-row';

    const numWrap = document.createElement('div');
    numWrap.className = 'tt-num-wrap';
    const numSpan = document.createElement('span');
    numSpan.className = 'tt-num';
    numSpan.textContent = globalIdx + 1;
    numWrap.appendChild(numSpan);
    if (track.id) {
      numWrap.appendChild(makePlayBtn(track.id));
    }

    const info = document.createElement('div');
    info.className = 'tt-info';
    const nameEl = document.createElement('span');
    nameEl.className = 'tt-name';
    nameEl.textContent = track.name;
    nameEl.style.cursor = 'pointer';
    nameEl.addEventListener('click', () => {
      window.location.href = `/albums/${track.album_id}`;
    });
    const albumEl = document.createElement('span');
    albumEl.className = 'tt-album';
    albumEl.textContent = track.album_name || '';
    info.appendChild(nameEl);
    info.appendChild(albumEl);

    const scoreEl = document.createElement('span');
    scoreEl.className = 'tt-score';
    scoreEl.textContent = track.avg_rating ? `★ ${track.avg_rating}` : '—';

    const durEl = document.createElement('span');
    durEl.className = 'tt-dur';
    durEl.textContent = fmtLength(track.length);

    row.appendChild(numWrap);
    row.appendChild(info);
    row.appendChild(scoreEl);
    row.appendChild(durEl);
    list.appendChild(row);
  });
}

function renderTopTracks(tracks, totalCount = 0) {
  const list    = document.getElementById('topTracksList');
  const showBtn = document.getElementById('showMoreTracks');
  list.innerHTML = '';

  if (!tracks.length) {
    list.innerHTML = '<p class="show-loading">no tracks yet</p>';
    showBtn.style.display = 'none';
    return;
  }

  renderBatch(tracks, list);

  // show button if there are more tracks than what's rendered
  const hasMore = totalCount > tracks.length;
  if (hasMore) {
    showBtn.style.display = 'block';
    showBtn.textContent = `show all ${totalCount} tracks`;
  } else {
    showBtn.style.display = 'none';
  }
}

// ── Render albums shelf ───────────────────────────
function renderAlbumsShelf(albums) {
  const shelf    = document.getElementById('albumsShelf');
  const btnLeft  = document.getElementById('shelfLeft');
  const btnRight = document.getElementById('shelfRight');
  shelf.innerHTML = '';

  if (!albums.length) {
    shelf.innerHTML = '<p class="show-loading">no albums yet</p>';
    btnLeft.style.display = btnRight.style.display = 'none';
    return;
  }

  albums.forEach(album => {
    const card = document.createElement('div');
    card.className = 'shelf-card';
    card.style.cursor = 'pointer';

    card.innerHTML = `
      <div class="shelf-card-bg"></div>
      <div class="shelf-card-cover-wrap">
        <img
          src="${escHtml(album.picture)}"
          alt="${escHtml(album.name)}"
          class="shelf-card-cover"
          onerror="this.src='/static/images/rateblock_outline.png'"
        >
      </div>
      <div class="shelf-card-info">
        <p class="shelf-card-title">${escHtml(album.name)}</p>
        <p class="shelf-card-year">${escHtml(album.release_date || '')}</p>
        <p class="shelf-card-type">${escHtml(album.release_type || '')}</p>
        ${album.avg_rating ? `<p class="shelf-card-score">★ ${album.avg_rating}</p>` : ''}
      </div>
      <button class="shelf-tl-btn" title="Add to ToListen">+</button>
    `;

    card.addEventListener('click', (e) => {
      if (e.target.closest('.shelf-tl-btn')) return;
      window.location.href = `/albums/${album.id}`;
    });

    const tlBtn = card.querySelector('.shelf-tl-btn');
    if (album.in_tolisten) {
      tlBtn.textContent = '✓';
      tlBtn.classList.add('shelf-tl-saved');
      tlBtn.disabled = true;
    }
    tlBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      openToListenPopup(album.id, album.name, () => {
        tlBtn.textContent = '✓';
        tlBtn.classList.add('shelf-tl-saved');
        tlBtn.disabled = true;
      });
    });
    shelf.appendChild(card);
  });

  const VISIBLE = 5;
  const total   = albums.length;
  let currentIndex = 0;
  let isScrolling  = false;

  function cardWidth() {
    const card = shelf.querySelector('.shelf-card');
    return card ? card.offsetWidth + 22 : 0;
  }

  function scrollToIndex(index) {
    if (isScrolling) return;
    currentIndex = Math.max(0, Math.min(index, total - VISIBLE));
    isScrolling = true;
    shelf.scrollTo({ left: currentIndex * cardWidth(), behavior: 'smooth' });
    updateArrows();
    setTimeout(() => { isScrolling = false; }, 400);
  }

  function updateArrows() {
    btnLeft.disabled  = currentIndex <= 0;
    btnRight.disabled = currentIndex >= total - VISIBLE;
  }

  btnLeft.addEventListener('click',  () => scrollToIndex(currentIndex - 1));
  btnRight.addEventListener('click', () => scrollToIndex(currentIndex + 1));

  if (total <= VISIBLE) {
    btnLeft.style.display = btnRight.style.display = 'none';
  } else {
    updateArrows();
  }
}

// ── Fetch & render ────────────────────────────────
async function loadArtist() {
  const artistId = window.ARTIST_ID;
  try {
    const res  = await apiFetch(`/api/artists/${artistId}?limit=5`);
    if (!res) return;
    const data = await res.json();
    const genres = data.Albums.flatMap(a => a.genres || [])
      .filter((g, i, arr) => arr.findIndex(x => x.id === g.id) === i);

    renderHero(data.Artist, data.Albums.length, genres);
    renderTopTracks(data.Top_songs || [], data.total_top_songs || 0);
    renderAlbumsShelf(data.Albums  || []);

    document.querySelectorAll('.show-loading').forEach(el => el.remove());

    // lazy load all tracks on button click
    const showBtn = document.getElementById('showMoreTracks');
    if (showBtn && showBtn.style.display !== 'none') {
      showBtn.addEventListener('click', async () => {
        showBtn.textContent = 'loading…';
        showBtn.disabled = true;
        const res2 = await apiFetch(`/api/artists/${artistId}`);
        if (!res2) return;
        const data2 = await res2.json();
        const list = document.getElementById('topTracksList');
        // append only the tracks not yet shown
        renderBatch((data2.Top_songs || []).slice(TRACKS_PREVIEW), list);
        showBtn.style.display = 'none';
      }, { once: true });
    }

  } catch (err) {
    console.error('Failed to load artist:', err);
    document.getElementById('topTracksList').textContent = 'could not load artist :(';
  }
}

loadArtist();