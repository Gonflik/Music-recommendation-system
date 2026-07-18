import { updateNav } from './navbar.js';
import { apiFetch } from './api.js';

updateNav();

if (!localStorage.getItem('access_token')) {
  window.location.href = '/users/login';
}

let currentPage = 1;
const PER_PAGE  = 10;
let totalCount  = 0;


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

function starsHtml(score, max = 5) {
  const filled = Math.min(Math.round(score), max);
  return '★'.repeat(filled) + '☆'.repeat(max - filled);
}

// ── State ─────────────────────────────────────────
let allRatings = [];
let activeTab  = 'all';
let activeSort = 'newest';

// ── Sort ──────────────────────────────────────────
function sortRatings(ratings) {
  const copy = [...ratings];
  switch (activeSort) {
    case 'highest': return copy.sort((a, b) => b.score - a.score);
    case 'lowest':  return copy.sort((a, b) => a.score - b.score);
    case 'az':      return copy.sort((a, b) => {
      const nameA = (a.Album?.name || a.Song?.name || '').toLowerCase();
      const nameB = (b.Album?.name || b.Song?.name || '').toLowerCase();
      return nameA.localeCompare(nameB);
    });
    default: return copy;
  }
}

// ── Edit modal ────────────────────────────────────
function openEditModal(rating, onSave, onDelete) {
  const existing = document.getElementById('ratingEditOverlay');
  if (existing) existing.remove();

  const isAlbum  = !!rating.Album;
  const item     = isAlbum ? rating.Album : rating.Song;
  const maxScore = isAlbum ? 10 : 5;

  let selectedScore = rating.score;

  const overlay = document.createElement('div');
  overlay.id = 'ratingEditOverlay';
  overlay.className = 'rating-edit-overlay';

  overlay.innerHTML = `
    <div class="rating-edit-modal">
      <div class="rating-edit-modal-bg"></div>
      <button class="rating-edit-close" id="editClose">✕</button>
      <div class="rating-edit-content">
        <div class="rating-edit-header">
          <img
            src="${escHtml(item.picture)}"
            alt="${escHtml(item.name)}"
            class="rating-edit-cover"
            onerror="this.src='/static/images/rateblock_outline.png'"
          >
          <div class="rating-edit-meta">
            <span class="rating-edit-type-tag">${isAlbum ? 'Album' : 'Song'}</span>
            <h3 class="rating-edit-title">${escHtml(item.name)}</h3>
            <p class="rating-edit-artist">${escHtml(item.artist_name)}</p>
          </div>
        </div>

        <div class="rating-edit-score-row" id="editScoreRow">
          ${isAlbum
            ? Array.from({length: 10}, (_, i) => i + 1).map(n =>
                `<button class="rating-edit-num-btn${n === selectedScore ? ' selected' : ''}" data-val="${n}">${n}</button>`
              ).join('')
            : Array.from({length: 5}, (_, i) => i + 1).map(n =>
                `<span class="rating-edit-star${n <= selectedScore ? ' filled' : ''}" data-val="${n}">★</span>`
              ).join('')
          }
        </div>

        <textarea class="rating-edit-desc" id="editDesc"
          placeholder="your thoughts… (optional)"
          rows="5" maxlength="1000">${escHtml(rating.description || '')}</textarea>

        <div class="rating-edit-actions">
          <button class="rating-edit-delete" id="editDelete">delete rating</button>
          <div class="rating-edit-right">
            <button class="rating-edit-cancel" id="editCancel">cancel</button>
            <button class="rating-edit-submit" id="editSubmit">save</button>
          </div>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(overlay);
  document.body.style.overflow = 'hidden';

  // score interaction
  const scoreRow = document.getElementById('editScoreRow');
  if (isAlbum) {
    scoreRow.querySelectorAll('.rating-edit-num-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        selectedScore = +btn.dataset.val;
        scoreRow.querySelectorAll('.rating-edit-num-btn').forEach(b => b.classList.remove('selected'));
        btn.classList.add('selected');
      });
    });
  } else {
    scoreRow.querySelectorAll('.rating-edit-star').forEach(star => {
      star.addEventListener('mouseenter', () => {
        const v = +star.dataset.val;
        scoreRow.querySelectorAll('.rating-edit-star').forEach(s => {
          s.classList.toggle('filled', +s.dataset.val <= v);
          s.classList.toggle('hovered', +s.dataset.val <= v);
        });
      });
      star.addEventListener('mouseleave', () => {
        scoreRow.querySelectorAll('.rating-edit-star').forEach(s => {
          s.classList.remove('hovered');
          s.classList.toggle('filled', +s.dataset.val <= selectedScore);
        });
      });
      star.addEventListener('click', () => {
        selectedScore = +star.dataset.val;
        scoreRow.querySelectorAll('.rating-edit-star').forEach(s => {
          s.classList.toggle('filled', +s.dataset.val <= selectedScore);
        });
      });
    });
  }

  const close = () => {
    overlay.remove();
    document.body.style.overflow = '';
  };

  document.getElementById('editClose').addEventListener('click', close);
  document.getElementById('editCancel').addEventListener('click', close);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });

  document.getElementById('editSubmit').addEventListener('click', async () => {
    const desc = document.getElementById('editDesc').value.trim() || null;
    const btn  = document.getElementById('editSubmit');
    btn.textContent = '…'; btn.disabled = true;
    try {
      const res = await apiFetch(`/api/users/me/ratings/${rating.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ score: selectedScore, description: desc }),
      });
      if (!res || !res.ok) throw new Error();
      rating.score = selectedScore;
      rating.description = desc;
      close();
      onSave(rating);
    } catch {
      btn.textContent = 'save'; btn.disabled = false;
    }
  });

  document.getElementById('editDelete').addEventListener('click', async () => {
    if (!confirm('delete this rating?')) return;
    const btn = document.getElementById('editDelete');
    btn.textContent = '…'; btn.disabled = true;
    try {
      const res = await apiFetch(`/api/users/me/ratings/${rating.id}`, {
        method: 'DELETE',
      });
      if (!res || !res.ok) throw new Error();
      close();
      onDelete(rating.id);
    } catch {
      btn.textContent = 'delete rating'; btn.disabled = false;
    }
  });
}

// ── Rating card (unified RYM style) ──────────────
function makeRatingCard(rating) {
  const isAlbum = !!rating.Album;
  const item    = isAlbum ? rating.Album : rating.Song;

  const card = document.createElement('article');
  card.className = 'rating-card';
  card.dataset.ratingId = rating.id;

  const scoreDisplay = isAlbum
    ? `<span class="rating-score-num">${rating.score}<span class="rating-score-denom">/10</span></span>`
    : `<span class="rating-score-stars">${starsHtml(rating.score)}</span>`;

  const metaLine = isAlbum
    ? `${escHtml(item.release_date || '')}${item.release_type ? ' · ' + escHtml(item.release_type) : ''}`
    : `${escHtml(item.artist_name)} · ${escHtml(item.album_name)}${item.length ? ' · ' + fmtLength(item.length) : ''}`;

  card.innerHTML = `
    <div class="rating-card-left">
      <img
        src="${escHtml(item.picture)}"
        alt="${escHtml(item.name)}"
        class="rating-card-cover"
        onerror="this.src='/static/images/rateblock_outline.png'"
      >
    </div>
    <div class="rating-card-body">
      <div class="rating-card-top">
        <div class="rating-card-title-wrap">
          <span class="rating-type-pill">${isAlbum ? 'Album' : 'Song'}</span>
          <h3 class="rating-card-title">${escHtml(item.name)}</h3>
          <p class="rating-card-meta">${metaLine}</p>
        </div>
        <div class="rating-card-score-wrap">
          ${scoreDisplay}
        </div>
      </div>
      ${rating.description
        ? `<p class="rating-card-desc">${escHtml(rating.description)}</p>`
        : '<p class="rating-card-no-desc">no notes written</p>'
      }
    </div>
    <button class="rating-card-edit-btn" title="edit rating">✎</button>
  `;

  // cover + title click → album page
  const dest = isAlbum ? `/albums/${item.id}` : `/albums/${item.album_id}`;
  card.querySelector('.rating-card-cover').addEventListener('click', () => window.location.href = dest);
  card.querySelector('.rating-card-title').addEventListener('click', () => window.location.href = dest);

  // edit button
  card.querySelector('.rating-card-edit-btn').addEventListener('click', (e) => {
    e.stopPropagation();
    openEditModal(
      rating,
      (updated) => {
        // re-render updated card in place
        const newCard = makeRatingCard(updated);
        card.replaceWith(newCard);
      },
      (deletedId) => {
        allRatings = allRatings.filter(r => r.id !== deletedId);
        render();
      }
    );
  });

  return card;
}

function renderPagination() {
  const pag       = document.getElementById('ratingsPagination');
  const prevBtn   = document.getElementById('ratingsPrevBtn');
  const nextBtn   = document.getElementById('ratingsNextBtn');
  const indicator = document.getElementById('ratingsPageIndicator');

  const totalPages = Math.ceil(totalCount / PER_PAGE);
  pag.style.display = totalPages > 1 ? 'flex' : 'none';
  prevBtn.disabled  = currentPage <= 1;
  nextBtn.disabled  = currentPage >= totalPages;
  indicator.textContent = `page ${currentPage} of ${totalPages}`;
}


// ── Render ────────────────────────────────────────
function render() {
  const sorted = sortRatings(allRatings);
  const albums = sorted.filter(r => r.Album);
  const songs  = sorted.filter(r => r.Song);

  document.getElementById('ratingsCount').textContent =
    `${totalCount} rating${totalCount !== 1 ? 's' : ''}`;

  const empty = document.getElementById('ratingsEmpty');
  if (!allRatings.length) { empty.classList.remove('hidden'); return; }
  empty.classList.add('hidden');

  document.querySelectorAll('.tab-panel').forEach(p => p.classList.add('hidden'));
  const panelId = `panel${activeTab.charAt(0).toUpperCase() + activeTab.slice(1)}`;
  document.getElementById(panelId).classList.remove('hidden');

  function fillList(containerId, items, emptyMsg) {
    const el = document.getElementById(containerId);
    el.innerHTML = '';
    if (!items.length) {
      el.innerHTML = `<p class="ratings-empty-tab">${emptyMsg}</p>`;
      return;
    }
    items.forEach(r => el.appendChild(makeRatingCard(r)));
  }

  if (activeTab === 'all') {
    const allSection = document.getElementById('allAlbumsSection');
    const songSection = document.getElementById('allSongsSection');

    albums.length ? allSection.classList.remove('hidden') : allSection.classList.add('hidden');
    songs.length  ? songSection.classList.remove('hidden') : songSection.classList.add('hidden');

    fillList('allAlbumsGrid', albums, '');
    fillList('allSongsList',  songs,  '');
  }

  if (activeTab === 'albums') fillList('albumsGrid', albums, 'no album ratings yet');
  if (activeTab === 'songs')  fillList('songsList',  songs,  'no song ratings yet');
}

// ── Tabs + Sort ───────────────────────────────────
document.querySelectorAll('.ratings-tab').forEach(tab => {
  tab.addEventListener('click', () => {
    document.querySelectorAll('.ratings-tab').forEach(t => t.classList.remove('tab-active'));
    tab.classList.add('tab-active');
    activeTab = tab.dataset.tab;
    render();
  });
});

document.querySelectorAll('.sort-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.sort-btn').forEach(b => b.classList.remove('sort-active'));
    btn.classList.add('sort-active');
    activeSort = btn.dataset.sort;
    render();
  });
});

document.getElementById('ratingsPrevBtn').addEventListener('click', () => {
  if (currentPage > 1) loadRatings(currentPage - 1);
});
document.getElementById('ratingsNextBtn').addEventListener('click', () => {
  loadRatings(currentPage + 1);
});

// ── Load ──────────────────────────────────────────
async function loadRatings(page = 1) {
  try {
    document.getElementById('ratingsLoading').style.display = 'block';
    const res = await apiFetch(`/api/me/ratings?page=${page}&per_page=${PER_PAGE}`);
    if (!res) return;
    const data = await res.json();
    allRatings  = data.Ratings || [];
    totalCount  = data.total   || allRatings.length;
    currentPage = page;

    document.getElementById('ratingsLoading').style.display = 'none';
    render();
    renderPagination();
  } catch (err) {
    console.error('Failed to load ratings:', err);
    document.getElementById('ratingsLoading').textContent = 'could not load ratings :(';
  }
}


loadRatings(1);