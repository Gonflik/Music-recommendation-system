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
  return String(str ?? '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
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
  t.textContent = msg;
  t.className = 'toast ' + (ok ? 'toast-ok' : 'toast-err') + ' toast-show';
  clearTimeout(t._timer);
  t._timer = setTimeout(() => t.classList.remove('toast-show'), 2800);
}


// ── Card builders ─────────────────────────────────
function makeAlbumCard(album) {
  const card = document.createElement('article');
  card.className = 'result-card result-album';
  card.innerHTML = `
    <div class="result-card-bg"></div>
    <img class="result-cover" src="${escHtml(album.picture)}" alt="${escHtml(album.name)}">
    <div class="result-info">
      <span class="result-type-tag">Album</span>
      <h3 class="result-title">${escHtml(album.name)}</h3>
      <p class="result-sub">${escHtml(album.artist_name)}</p>
      <p class="result-meta">${escHtml(album.release_date || '')}${album.release_type ? ' · ' + escHtml(album.release_type) : ''}</p>
      ${album.avg_rating ? `<p class="result-rating">★ ${album.avg_rating}</p>` : ''}
    </div>
    <button class="tl-btn" data-album-id="${album.id}">+ ToListen</button>
  `;

  // set initial state
  const tlBtn = card.querySelector('.tl-btn');
  if (album.in_tolisten) {
    tlBtn.textContent = '✓ saved';
    tlBtn.classList.add('tl-btn-saved');
    tlBtn.disabled = true;
  }

  card.addEventListener('click', (e) => {
    if (e.target.closest('.tl-btn')) return;
    window.location.href = `/albums/${album.id}`;
  });

  tlBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    openToListenPopup(album.id, album.name, () => {
      tlBtn.textContent = '✓ saved';
      tlBtn.classList.add('tl-btn-saved');
      tlBtn.disabled = true;
    });
  });

  return card;
}

function makeSongCard(song) {
  const card = document.createElement('article');
  card.className = 'result-card result-song';

  // cover wrap — needed for play button overlay
  const coverWrap = document.createElement('div');
  coverWrap.className = 'result-cover-wrap';

  const img = document.createElement('img');
  img.className = 'result-cover';
  img.src = escHtml(song.picture);
  img.alt = escHtml(song.name);
  coverWrap.appendChild(img);


  coverWrap.appendChild(makePlayBtn(song.id));

  const cardBg = document.createElement('div');
  cardBg.className = 'result-card-bg';

  const info = document.createElement('div');
  info.className = 'result-info';
  info.innerHTML = `
    <span class="result-type-tag result-type-song">Song</span>
    <h3 class="result-title">${escHtml(song.name)}</h3>
    <p class="result-sub">${escHtml(song.artist_name)}</p>
    <p class="result-meta">${escHtml(song.album_name)}${song.length ? ' · ' + fmtLength(song.length) : ''}</p>
    ${song.avg_rating ? `<p class="result-rating">★ ${song.avg_rating}</p>` : ''}
  `;

  card.appendChild(cardBg);
  card.appendChild(coverWrap);
  card.appendChild(info);

  card.addEventListener('click', (e) => {
    if (e.target.closest('.preview-btn')) return;
    window.location.href = `/albums/${song.album_id}`;
  });

  return card;
}

function makeArtistCard(artist) {
  const card = document.createElement('article');
  card.className = 'result-card result-artist';
  card.innerHTML = `
    <div class="result-card-bg"></div>
    <img class="result-cover result-cover-round" src="${escHtml(artist.picture)}" alt="${escHtml(artist.name)}">
    <div class="result-info">
      <span class="result-type-tag result-type-artist">Artist</span>
      <h3 class="result-title">${escHtml(artist.name)}</h3>
      <p class="result-meta">${artist.ghost_albums_count ? artist.ghost_albums_count + ' albums' : ''}</p>
    </div>
  `;
  card.addEventListener('click', () => window.location.href = `/artists/${artist.id}`);
  return card;
}

// ── Render results ────────────────────────────────
function renderResults(data) {
  const container = document.getElementById('searchResults');
  container.innerHTML = '';

  const albums  = data.Albums  || [];
  const songs   = data.Songs   || [];
  const artists = data.Artists || [];

  if (!albums.length && !songs.length && !artists.length) {
    container.innerHTML = '<p class="search-hint">no results found — try something else</p>';
    return;
  }

  function makeSection(label, cards) {
    if (!cards.length) return;
    const section = document.createElement('section');
    section.className = 'results-section';
    section.innerHTML = `<h2 class="results-section-title">${label}</h2>`;
    const grid = document.createElement('div');
    grid.className = 'results-grid';
    cards.forEach(c => grid.appendChild(c));
    section.appendChild(grid);
    container.appendChild(section);
  }

  makeSection('Albums',  albums.map(makeAlbumCard));
  makeSection('Artists', artists.map(makeArtistCard));
  makeSection('Songs',   songs.map(makeSongCard));
}

// ── Pagination ────────────────────────────────────
let currentLinks = {};

function updatePagination(links) {
  currentLinks = links || {};
  const pag       = document.getElementById('searchPagination');
  const prevBtn   = document.getElementById('prevBtn');
  const nextBtn   = document.getElementById('nextBtn');
  const indicator = document.getElementById('pageIndicator');

  const hasAny = currentLinks.next_page || currentLinks.prev_page;
  pag.style.display = hasAny ? 'flex' : 'none';
  prevBtn.disabled = !currentLinks.prev_page;
  nextBtn.disabled = !currentLinks.next_page;

  if (currentLinks.next_page) {
    const match = currentLinks.next_page.match(/page=(\d+)/);
    if (match) indicator.textContent = `page ${Number(match[1]) - 1}`;
  } else if (currentLinks.prev_page) {
    const match = currentLinks.prev_page.match(/page=(\d+)/);
    if (match) indicator.textContent = `page ${Number(match[1]) + 1}`;
  }
}

async function fetchPage(url) {
  const container = document.getElementById('searchResults');
  container.innerHTML = '<p class="search-hint searching">searching…</p>';
  try {
    const res = await apiFetch(url);
    if (!res || !res.ok) throw new Error();
    const data = await res.json();
    renderResults(data);
    updatePagination(data.links);
  } catch {
    container.innerHTML = '<p class="search-hint">something went wrong :(</p>';
  }
}

document.getElementById('prevBtn').addEventListener('click', () => {
  if (currentLinks.prev_page) fetchPage(currentLinks.prev_page);
});
document.getElementById('nextBtn').addEventListener('click', () => {
  if (currentLinks.next_page) fetchPage(currentLinks.next_page);
});

// ── Search input ──────────────────────────────────
const input    = document.getElementById('searchInput');
const clearBtn = document.getElementById('searchClear');
let debounceTimer;

input.addEventListener('input', () => {
  const q = input.value.trim();
  clearBtn.style.display = q ? 'flex' : 'none';
  clearTimeout(debounceTimer);

  if (!q) {
    document.getElementById('searchResults').innerHTML = '<p class="search-hint">start typing to search</p>';
    document.getElementById('searchPagination').style.display = 'none';
    return;
  }

  debounceTimer = setTimeout(() => {
    fetchPage(`/api/search?q=${encodeURIComponent(q)}&page=1&per_page=5`);
  }, 400);
});

clearBtn.addEventListener('click', () => {
  input.value = '';
  clearBtn.style.display = 'none';
  document.getElementById('searchResults').innerHTML = '<p class="search-hint">start typing to search</p>';
  document.getElementById('searchPagination').style.display = 'none';
  input.focus();
});

// prefill from URL query param
input.focus();
const params = new URLSearchParams(window.location.search);
const q = params.get('q');
if (q) {
  input.value = q;
  clearBtn.style.display = 'flex';
  fetchPage(`/api/search?q=${encodeURIComponent(q)}&page=1&per_page=5`);
}