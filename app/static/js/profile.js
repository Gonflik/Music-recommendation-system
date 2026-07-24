import { updateNav } from './navbar.js';
import { apiFetch } from './api.js';

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

function starsHtml(score) {
  const filled = Math.round(score);
  return '★'.repeat(filled) + '☆'.repeat(5 - filled);
}

function getInitials(name) {
  return (name || '?').split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase();
}

// ── Determine if viewing own profile ─────────────
const profileUserId = window.PROFILE_USER_ID;
let isOwnProfile    = false;

// ── Render hero ───────────────────────────────────
function renderHero(user) {
  // avatar initials
  const avatar = document.getElementById('profileAvatar');
  const imgIndex = (profileUserId % 7) + 1;
  avatar.innerHTML = `<img src="/static/images/pfp/${imgIndex}.jpeg" alt="avatar" class="profile-avatar-img">`;

  document.getElementById('profileName').textContent = user.name;
  document.title = `${user.name} – ratestuff.fm`;

  // meta line
  const metaParts = [];
  if (user.location) metaParts.push(user.location);
  if (user.age)      metaParts.push(`${user.age} y/o`);
  if (user.gender && user.gender !== 'prefer_not_to_say') metaParts.push(user.gender);
  document.getElementById('profileMeta').textContent = metaParts.join(' · ');

  // bio
  const bioEl = document.getElementById('profileBio');
  bioEl.textContent = user.bio || '';
  bioEl.classList.toggle('hidden', !user.bio);

  // show edit button only on own profile
  if (isOwnProfile) {
    document.getElementById('profileEditBtn').classList.remove('hidden');
  }
}

// ── Render stats ──────────────────────────────────
function renderStats(stats) {
  document.getElementById('statRatings').textContent  = stats.ratings_count ?? 0;
  document.getElementById('statAlbums').textContent   = stats.albums_rated  ?? 0;
  document.getElementById('statSongs').textContent    = stats.songs_rated   ?? 0;
  document.getElementById('statToListen').textContent = stats.tolisten_count ?? 0;
}

// ── Activity item ─────────────────────────────────
function makeRatingItem(rating) {
  const isAlbum = !!rating.Album;
  const item    = isAlbum ? rating.Album : rating.Song;
  const dest    = isAlbum ? `/albums/${item.id}` : `/albums/${item.album_id}`;

  const scoreDisplay = isAlbum
    ? `<span class="activity-score-num">${rating.score}<span class="activity-score-denom">/10</span></span>`
    : `<span class="activity-score-stars">${starsHtml(rating.score)}</span>`;

  const el = document.createElement('div');
  el.className = 'activity-item';
  el.innerHTML = `
    <img
      src="${escHtml(item.picture)}"
      alt="${escHtml(item.name)}"
      class="activity-cover"
      onerror="this.src='/static/images/rateblock_outline.png'"
    >
    <div class="activity-info">
      <span class="activity-type-pill">${isAlbum ? 'Album' : 'Song'}</span>
      <span class="activity-name">${escHtml(item.name)}</span>
      <span class="activity-sub">${escHtml(item.artist_name)}</span>
      ${rating.description ? `<span class="activity-desc">"${escHtml(rating.description)}"</span>` : ''}
    </div>
    <div class="activity-score">${scoreDisplay}</div>
  `;
  el.style.cursor = 'pointer';
  el.addEventListener('click', () => window.location.href = dest);
  return el;
}

function makeToListenItem(entry) {
  const album = entry.Album;
  const el    = document.createElement('div');
  el.className = 'activity-item';
  el.innerHTML = `
    <img
      src="${escHtml(album.picture)}"
      alt="${escHtml(album.name)}"
      class="activity-cover"
      onerror="this.src='/static/images/rateblock_outline.png'"
    >
    <div class="activity-info">
      <span class="activity-type-pill activity-type-tl">ToListen</span>
      <span class="activity-name">${escHtml(album.name)}</span>
      <span class="activity-sub">${escHtml(album.artist_name)}</span>
      ${entry.note ? `<span class="activity-desc">"${escHtml(entry.note)}"</span>` : ''}
    </div>
  `;
  el.style.cursor = 'pointer';
  el.addEventListener('click', () => window.location.href = `/albums/${album.id}`);
  return el;
}

function renderActivity(recentRatings, recentToListen) {
  const ratingsEl   = document.getElementById('recentRatings');
  const toListenEl  = document.getElementById('recentToListen');

  ratingsEl.innerHTML = '';
  toListenEl.innerHTML = '';

  if (!recentRatings.length) {
    ratingsEl.innerHTML = '<p class="profile-empty">no ratings yet</p>';
  } else {
    recentRatings.forEach(r => ratingsEl.appendChild(makeRatingItem(r)));
  }

  if (!recentToListen.length) {
    toListenEl.innerHTML = '<p class="profile-empty">nothing added yet</p>';
  } else {
    recentToListen.forEach(t => toListenEl.appendChild(makeToListenItem(t)));
  }
}

// ── Edit profile ──────────────────────────────────
let currentUser = null;

function initEditProfile() {
  const editBtn    = document.getElementById('profileEditBtn');
  const editForm   = document.getElementById('profileEditForm');
  const cancelBtn  = document.getElementById('editCancelBtn');
  const saveBtn    = document.getElementById('editSaveBtn');
  const nameInput  = document.getElementById('editName');
  const bioInput   = document.getElementById('editBio');

  editBtn.addEventListener('click', () => {
    nameInput.value = currentUser.name  || '';
    bioInput.value  = currentUser.bio   || '';
    editForm.classList.remove('hidden');
    editBtn.classList.add('hidden');
    nameInput.focus();
  });

  cancelBtn.addEventListener('click', () => {
    editForm.classList.add('hidden');
    editBtn.classList.remove('hidden');
  });

  saveBtn.addEventListener('click', async () => {
    const name = nameInput.value.trim();
    const bio  = bioInput.value.trim() || null;
    if (!name) { nameInput.focus(); return; }

    saveBtn.textContent = '…';
    saveBtn.disabled    = true;

    try {
      const res = await apiFetch(`/api/users/${profileUserId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, bio }),
      });
      if (!res || !res.ok) throw new Error();

      currentUser.name = name;
      currentUser.bio  = bio;

      document.getElementById('profileName').textContent = name;
      document.title = `${name} – ratestuff.fm`;
      document.getElementById('profileAvatar').textContent = getInitials(name);

      const bioEl = document.getElementById('profileBio');
      bioEl.textContent = bio || '';
      bioEl.classList.toggle('hidden', !bio);

      editForm.classList.add('hidden');
      editBtn.classList.remove('hidden');
    } catch {
      // silent fail — keep form open
    } finally {
      saveBtn.textContent = 'save';
      saveBtn.disabled    = false;
    }
  });
}

// ── Load ──────────────────────────────────────────
async function loadProfile() {
  try {
    // check if own profile by decoding JWT user id
    // we compare against stored user_id if available
    const storedId = localStorage.getItem('user_id');
    if (storedId && Number(storedId) === profileUserId) {
      isOwnProfile = true;
    }

    const res = await apiFetch(`/api/users/${profileUserId}/profile`);
    if (!res) return;
    const data = await res.json();

    currentUser = data.User;

    renderHero(data.User);
    renderStats(data.stats);
    renderActivity(data.recent_ratings || [], data.recent_tolisten || []);

    if (isOwnProfile) initEditProfile();

  } catch (err) {
    console.error('Failed to load profile:', err);
  }
}

loadProfile();