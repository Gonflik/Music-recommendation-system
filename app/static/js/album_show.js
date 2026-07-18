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

function getInitials(name) {
  return (name || '?').split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase();
}

// avatar color from name (deterministic)
const AVATAR_COLORS = ['#BA76BB','#7090C0','#E96F4C','#3cb464','#E8B857','#888'];
function avatarColor(name) {
  let hash = 0;
  for (const c of (name || '')) hash = c.charCodeAt(0) + ((hash << 5) - hash);
  return AVATAR_COLORS[Math.abs(hash) % AVATAR_COLORS.length];
}

// ── Flip notebook ─────────────────────────────────
let isFlipped       = false;
let ratingsLoaded   = false;
let ratingsPage     = 1;
const RATINGS_PER_PAGE = 5;
let totalRatings    = 0;
let allRatings      = [];

function flipNotebook() {
  isFlipped = !isFlipped;
  document.getElementById('notebookFlipInner').classList.toggle('flipped', isFlipped);
  document.body.classList.toggle('notebook-dark', isFlipped);

  const ribbon = document.getElementById('notebookRibbon');
  const ribbonLabel = document.getElementById('notebookRibbonLabel');

  // fade out
  ribbon.classList.add('ribbon-hidden');

  setTimeout(() => {
    // swap state + label at the midpoint
    ribbon.classList.toggle('active', isFlipped);
    ribbonLabel.textContent = isFlipped ? 'tracklist' : 'see ratings';
    // fade back in
    ribbon.classList.remove('ribbon-hidden');
  }, 350); // half of the 700ms flip

  if (isFlipped && !ratingsLoaded) {
    loadAlbumRatings();
  }
}

// Single ribbon button handles both directions
document.getElementById('notebookRibbon').addEventListener('click', flipNotebook);

// ── Load album ratings ────────────────────────────
async function loadAlbumRatings(page = 1) {
  try {
    const res = await apiFetch(
      `/api/artists/${currentArtistId}/albums/${window.ALBUM_ID}/ratings?page=${page}&per_page=${RATINGS_PER_PAGE}`
    );
    if (!res) return;
    const data = await res.json();
    allRatings    = data.Ratings || [];
    totalRatings  = data.total   || allRatings.length;
    ratingsPage   = page;
    ratingsLoaded = true;
    renderRatings();
    renderRatingsPagination();
  } catch (err) {
    console.error('Failed to load ratings:', err);
    document.getElementById('ratingsNotebookList').textContent = 'could not load ratings :(';
  }
}

// ── Render community ratings ──────────────────────
function renderRatings() {
  const list = document.getElementById('ratingsNotebookList');
  list.innerHTML = '';

  if (!allRatings.length) {
    list.innerHTML = '<p class="show-loading">no ratings yet — be the first!</p>';
    return;
  }

  allRatings.forEach(rating => {
    const user = rating.user || {};
    const imgIndex = (user.id % 7) + 1;

    const card = document.createElement('div');
    card.className = 'rating-notebook-card';

    card.innerHTML = `
      <div class="rnc-header">
        <a class="rnc-user" href="/users/${user.id}">
          <span class="rnc-avatar">
            <img src="/static/images/pfp/${imgIndex}.jpeg" alt="avatar" class="rnc-avatar-img">
          </span>
          <span class="rnc-username">${escHtml(user.name || 'anonymous')}</span>
        </a>
        <span class="rnc-score">${rating.score}<span class="rnc-score-denom">/10</span></span>
      </div>
      ${rating.description
        ? `<p class="rnc-desc">${escHtml(rating.description)}</p>`
        : `<p class="rnc-no-desc">no description written</p>`
      }
    `;

    list.appendChild(card);
  });
}

// ── Ratings pagination ────────────────────────────
function renderRatingsPagination() {
  const pag       = document.getElementById('ratingsNotebookPagination');
  const prevBtn   = document.getElementById('ratingsPrevBtn');
  const nextBtn   = document.getElementById('ratingsNextBtn');
  const indicator = document.getElementById('ratingsPageIndicator');

  const totalPages = Math.ceil(totalRatings / RATINGS_PER_PAGE);
  pag.style.display = totalPages > 1 ? 'flex' : 'none';
  prevBtn.disabled  = ratingsPage <= 1;
  nextBtn.disabled  = ratingsPage >= totalPages;
  indicator.textContent = `page ${ratingsPage} of ${totalPages}`;
}

document.getElementById('ratingsPrevBtn').addEventListener('click', () => {
  if (ratingsPage > 1) loadAlbumRatings(ratingsPage - 1);
});
document.getElementById('ratingsNextBtn').addEventListener('click', () => {
  loadAlbumRatings(ratingsPage + 1);
});

// ── Album rating modal ────────────────────────────
let selectedScore = null;
let currentAlbum  = null;

function openAlbumRatingModal(album, existingRating = null) {
  selectedScore = existingRating?.score ?? null;
  const overlay   = document.getElementById('albumRatingOverlay');
  const numbers   = document.getElementById('albumRatingNumbers');
  const desc      = document.getElementById('albumRatingDesc');
  const submitBtn = document.getElementById('albumRatingSubmit');

  document.getElementById('albumRatingSubtitle').textContent = album.name;
  desc.value = existingRating?.description ?? '';
  numbers.innerHTML = '';

  for (let i = 1; i <= 10; i++) {
    const btn = document.createElement('button');
    btn.className = 'album-rating-num-btn' + (i === selectedScore ? ' selected' : '');
    btn.textContent = i;
    btn.addEventListener('click', () => {
      selectedScore = i;
      numbers.querySelectorAll('.album-rating-num-btn').forEach(b => b.classList.remove('selected'));
      btn.classList.add('selected');
      submitBtn.disabled = false;
    });
    numbers.appendChild(btn);
  }

  submitBtn.disabled = selectedScore === null;
  overlay.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeAlbumRatingModal() {
  document.getElementById('albumRatingOverlay').classList.remove('open');
  document.body.style.overflow = '';
  selectedScore = null;
}

function initAlbumRatingModal() {
  document.getElementById('albumRatingClose').addEventListener('click', closeAlbumRatingModal);
  document.getElementById('albumRatingCancel').addEventListener('click', closeAlbumRatingModal);
  document.getElementById('albumRatingOverlay').addEventListener('click', (e) => {
    if (e.target === document.getElementById('albumRatingOverlay')) closeAlbumRatingModal();
  });

  document.getElementById('albumRatingSubmit').addEventListener('click', async () => {
    if (!selectedScore || !currentAlbum) return;
    const submitBtn = document.getElementById('albumRatingSubmit');
    const desc = document.getElementById('albumRatingDesc').value.trim() || null;
    submitBtn.textContent = '…';
    submitBtn.disabled = true;

    try {
      const res = await apiFetch(
        `/api/artists/${currentAlbum.artist_id}/albums/${currentAlbum.id}/ratings`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ score: selectedScore, description: desc }),
        }
      );
      if (!res || !res.ok) throw new Error();
      const rateBtn = document.getElementById('rateAlbumBtn');
      rateBtn.textContent = `★ ${selectedScore}/10`;
      rateBtn.classList.add('rated');
      // invalidate ratings cache so flip reloads
      ratingsLoaded = false;
      closeAlbumRatingModal();
    } catch (err) {
      console.error('Album rating error:', err);
      submitBtn.textContent = 'rate it';
      submitBtn.disabled = false;
    }
  });
}

// ── Song rating popup ─────────────────────────────
let activePopup = null;

function closeActivePopup() {
  if (activePopup) { activePopup.remove(); activePopup = null; }
}

document.addEventListener('click', (e) => {
  if (activePopup && !activePopup.contains(e.target) && !e.target.closest('.star-rating')) {
    closeActivePopup();
  }
});

function openRatingPopup(anchorEl, songId, score, onConfirm) {
  closeActivePopup();
  const popup = document.createElement('div');
  popup.className = 'rating-popup';
  popup.innerHTML = `
    <div class="rating-popup-inner">
      <div class="rating-popup-score">
        ${'★'.repeat(score)}${'☆'.repeat(5 - score)}
        <span class="rating-popup-num">${score} / 5</span>
      </div>
      <textarea class="rating-popup-desc" placeholder="add a note… (optional)" rows="3" maxlength="500"></textarea>
      <div class="rating-popup-actions">
        <button class="rating-popup-cancel">cancel</button>
        <button class="rating-popup-submit">rate it</button>
      </div>
    </div>
  `;

  const rect    = anchorEl.getBoundingClientRect();
  const scrollY = window.scrollY || document.documentElement.scrollTop;
  const scrollX = window.scrollX || document.documentElement.scrollLeft;
  popup.style.position = 'absolute';
  popup.style.top  = `${rect.bottom + scrollY + 8}px`;
  popup.style.left = `${rect.left  + scrollX}px`;
  document.body.appendChild(popup);
  activePopup = popup;

  const popupRect = popup.getBoundingClientRect();
  if (popupRect.right > window.innerWidth - 16) {
    popup.style.left = `${rect.right + scrollX - popupRect.width}px`;
  }

  popup.querySelector('.rating-popup-cancel').addEventListener('click', (e) => {
    e.stopPropagation(); closeActivePopup();
  });
  popup.querySelector('.rating-popup-submit').addEventListener('click', async (e) => {
    e.stopPropagation();
    const description = popup.querySelector('.rating-popup-desc').value.trim() || null;
    popup.querySelector('.rating-popup-submit').textContent = '…';
    popup.querySelector('.rating-popup-submit').disabled = true;
    await onConfirm(score, description);
    closeActivePopup();
  });
}

// ── Star widget (songs) ───────────────────────────
function makeStarWidget(songId, existingRating) {
  const wrap = document.createElement('div');
  wrap.className = 'star-rating';
  if (existingRating) wrap.classList.add('rated');
  wrap.dataset.songId = songId;
  let current = existingRating || 0;

  for (let i = 1; i <= 5; i++) {
    const star = document.createElement('span');
    star.className = 'star' + (i <= current ? ' filled' : '');
    star.textContent = '★';
    star.dataset.val = i;

    star.addEventListener('mouseenter', () => {
      wrap.querySelectorAll('.star').forEach(s => {
        s.classList.toggle('hovered', +s.dataset.val <= i);
        s.classList.remove('filled');
      });
    });
    star.addEventListener('mouseleave', () => {
      wrap.querySelectorAll('.star').forEach(s => {
        s.classList.remove('hovered');
        s.classList.toggle('filled', +s.dataset.val <= current);
      });
    });
    star.addEventListener('click', (e) => {
      e.stopPropagation();
      openRatingPopup(wrap, songId, i, async (confirmedScore, description) => {
        try {
          const body = { score: confirmedScore };
          if (description) body.description = description;
          const res = await apiFetch(`/api/artists/${currentArtistId}/songs/${songId}/ratings`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body),
          });
          if (!res || !res.ok) throw new Error('rate failed');
          current = confirmedScore;
          wrap.classList.add('rated');
          wrap.querySelectorAll('.star').forEach(s => {
            s.classList.toggle('filled', +s.dataset.val <= current);
          });
        } catch (err) { console.error('Rating error:', err); }
      });
    });
    wrap.appendChild(star);
  }
  return wrap;
}

let currentArtistId = null;

// ── Render hero ───────────────────────────────────
function renderHero(album, existingAlbumRating = null) {
  currentArtistId = album.artist_id;
  currentAlbum    = album;

  const coverSrc = album.picture || '/static/images/rateblock_outline.png';
  document.getElementById('showCover').src = coverSrc;
  document.getElementById('showCover').alt = album.name;
  document.getElementById('showType').textContent  = album.release_type || 'Album';
  document.getElementById('showTitle').textContent = album.name;

  const artistLink = document.getElementById('showArtistLink');
  artistLink.textContent = album.artist_name;
  artistLink.href = album.artist_id ? `/artists/${album.artist_id}` : '#';

  const details = document.getElementById('showDetailsRow');
  const parts = [album.release_date, album.Songs?.length ? album.Songs.length + ' songs' : null].filter(Boolean);
  details.innerHTML = parts.map((p, i) =>
    i > 0 ? `<span class="dot">·</span><span>${escHtml(String(p))}</span>`
           : `<span>${escHtml(String(p))}</span>`
  ).join('');

  const ratingSummary = document.getElementById('showRatingSummary');
  if (album.avg_rating) {
    ratingSummary.innerHTML = `
      <span class="show-avg-star">★</span>
      <span class="show-avg-score">${escHtml(String(album.avg_rating))}</span>
      ${album.rating_count ? `<span class="show-rating-count">${Number(album.rating_count).toLocaleString()} ratings</span>` : ''}
    `;
  }

  document.title = `${album.name} – ratestuff.fm`;

  document.getElementById('backBtn').addEventListener('click', () => {
    if (document.referrer) history.back();
    else window.location.href = '/explore';
  });

  const tlBtn = document.getElementById('heroTlBtn');
  if (album.in_tolisten) {
    tlBtn.textContent = '✓ saved';
    tlBtn.classList.add('tl-btn-saved');
    tlBtn.disabled = true;
  } else {
    tlBtn.addEventListener('click', () =>
      openToListenPopup(album.id, album.name, () => {
        tlBtn.textContent = '✓ saved';
        tlBtn.classList.add('tl-btn-saved');
        tlBtn.disabled = true;
      })
    );
  }

  const rateBtn = document.getElementById('rateAlbumBtn');
  if (existingAlbumRating) {
    rateBtn.textContent = `★ ${existingAlbumRating.score}/10`;
    rateBtn.classList.add('rated');
  }
  rateBtn.addEventListener('click', () => openAlbumRatingModal(album, existingAlbumRating));
}

// ── Render tracklist ──────────────────────────────
function renderTracklist(tracks) {
  const list = document.getElementById('tracklist');
  list.innerHTML = '';

  tracks.forEach((track, idx) => {
    const row = document.createElement('div');
    row.className = 'track-row';

    const numWrap = document.createElement('div');
    numWrap.className = 'tl-num-wrap';
    const numSpan = document.createElement('span');
    numSpan.className = 'tl-num';
    numSpan.textContent = idx + 1;
    numWrap.appendChild(numSpan);
    if (track.id) numWrap.appendChild(makePlayBtn(track.id));

    const titleCol = document.createElement('div');
    titleCol.className = 'tl-title-col';
    titleCol.innerHTML = `<span class="tl-track-name">${escHtml(track.name)}</span>`;

    let ratingEl;
    if (localStorage.getItem('access_token')) {
      ratingEl = makeStarWidget(track.id, track.user_rating);
    } else {
      ratingEl = document.createElement('span');
      ratingEl.className = 'rating-login-hint';
      ratingEl.textContent = 'log in to rate';
    }

    const avgEl = document.createElement('span');
    avgEl.className = 'tl-avg';
    avgEl.textContent = track.avg_rating ? `★ ${track.avg_rating}` : '—';

    const durEl = document.createElement('span');
    durEl.className = 'tl-dur';
    if (track.length) {
      const m = Math.floor(track.length / 60);
      const s = String(track.length % 60).padStart(2, '0');
      durEl.textContent = `${m}:${s}`;
    }

    row.appendChild(numWrap);
    row.appendChild(titleCol);
    row.appendChild(ratingEl);
    row.appendChild(avgEl);
    row.appendChild(durEl);
    list.appendChild(row);
  });
}

// ── Fetch & render ────────────────────────────────
async function loadAlbum() {
  const albumId = window.ALBUM_ID;
  try {
    const res = await apiFetch(`/api/albums/${albumId}`);
    if (!res) return;
    const data  = await res.json();
    const album = data.Album;

    initAlbumRatingModal();
    renderHero(album, data.user_album_rating ?? null);
    renderTracklist(album.Songs || []);
    document.querySelector('.show-loading')?.remove();
  } catch (err) {
    console.error('Failed to load album:', err);
    document.getElementById('tracklist').textContent = 'could not load album :(';
  }
}

loadAlbum();