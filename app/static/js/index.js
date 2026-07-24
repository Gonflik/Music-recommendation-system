// ── Burger menu ───────────────────────────────────
(function () {
  var btn = document.getElementById('burgerBtn');
  var nav = document.getElementById('mobileNav');
  var backdrop = document.getElementById('navBackdrop');
  var closeBtn = document.getElementById('navClose');
  function openNav() { btn.classList.add('open'); nav.classList.add('open'); document.body.style.overflow = 'hidden'; }
  function closeNav() { btn.classList.remove('open'); nav.classList.remove('open'); document.body.style.overflow = ''; }
  btn.addEventListener('click', function () { nav.classList.contains('open') ? closeNav() : openNav(); });
  closeBtn.addEventListener('click', closeNav);
  backdrop.addEventListener('click', closeNav);
})();

const ctaBtn = document.getElementById('ctaBtn');
if (ctaBtn) {
  if (localStorage.getItem('access_token')) {
    ctaBtn.href = '/explore';
    ctaBtn.textContent = 'Jump Back';
  } else {
    ctaBtn.href = '/users';
    ctaBtn.textContent = 'Get Started';
  }
}

// ── Top Rated section ─────────────────────────────
async function loadTopRated() {
  const grid = document.getElementById('topRatedGrid');

  try {
    const res = await fetch('/api/songs/top-rated');
    if (!res.ok) throw new Error('API error ' + res.status);
    const data = await res.json();
    const songs = data.top_songs;

    grid.innerHTML = '';

    songs.forEach(song => {
      const coverSrc = song.picture
        ? song.picture
        : '/static/images/rating_outline.png';

      const countStr = song.rating_count
        ? Number(song.rating_count).toLocaleString() + ' ratings'
        : '';
      const durationStr = song.length || '';
      const metaLine = [countStr, durationStr].filter(Boolean).join(' · ');

      const item = document.createElement('div');
      item.className = 'tr-item';
      item.innerHTML = `
        <article class="tr-card">
          <div class="tr-card-bg"></div>
          <div class="tr-cover-wrap">
            <img src="${escHtml(coverSrc)}" alt="${escHtml(song.name)}" class="tr-cover">
          </div>
          <div class="tr-meta">
            <h3 class="tr-title">${escHtml(song.name)}</h3>
            <p class="tr-artist">${escHtml(song.artist_name)}</p>
          </div>
          <div class="tr-rating-row">
            <span class="tr-score">★ ${escHtml(String(song.avg_rating ?? '—'))}</span>
            ${metaLine ? `<span class="tr-count">${escHtml(metaLine)}</span>` : ''}
          </div>
        </article>`;
      grid.appendChild(item);
            item.addEventListener('click', () => {
        if (localStorage.getItem('access_token')) {
          window.location.href = `/albums/${song.album_id}`;
        } else {
          window.location.href = '/users';
        }
      });
    });

  } catch (err) {
    console.error('Failed to load top-rated:', err);
    grid.innerHTML = '<p style="padding:1rem;font-family:\'Indie Flower\',cursive;">could not load top rated right now :(</p>';
  }
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
import { updateNav } from './navbar.js';

updateNav();

loadTopRated();
