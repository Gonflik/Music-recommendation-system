import { updateNav } from './navbar.js';
import { apiFetch } from './api.js';

updateNav();

if (!localStorage.getItem('access_token')) {
  window.location.href = '/users/login';
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

const NOTE_COLORS    = ['note-yellow', 'note-green', 'note-pink', 'note-blue'];
const ROTATIONS      = [-1.5, 1.1, -0.6, 2.0, -1.8, 0.7, -0.3];
const NOTE_ROTATIONS = [1.2, -1.6, 0.5, -2.1, 1.8, -0.4, 1.0];

let cardCount = 0;

// ── "Already listened" section ────────────────────
function getOrCreateListenedSection() {
  let section = document.getElementById('listenedSection');
  if (section) return section;

  section = document.createElement('section');
  section.id = 'listenedSection';
  section.style.display = 'none'; // hidden until we have ≥1 card
  section.innerHTML = `
    <div class="page-header" style="margin-top: 64px; margin-bottom: 52px;">
      <div class="page-header-bg"></div>
      <h2 class="page-title">already listened</h2>
      <p class="page-subtitle">the ones you've actually gotten around to</p>
    </div>
    <div class="tolisten-grid" id="listenedGrid"></div>
  `;

  // Insert after <main> or append to page-content
  const main = document.querySelector('main.page-content');
  main.appendChild(section);

  return section;
}

function syncListenedSectionVisibility() {
  const section = document.getElementById('listenedSection');
  if (!section) return;
  const grid = document.getElementById('listenedGrid');
  section.style.display = grid && grid.children.length > 0 ? '' : 'none';
}

// ── Move card between grids ───────────────────────
function moveCard(wrapper, toListened) {
  const toGrid   = document.getElementById('tolistenGrid');
  const addItem  = toGrid.querySelector('.tl-add-item');

  if (toListened) {
    const listenedSection = getOrCreateListenedSection();
    const listenedGrid    = listenedSection.querySelector('#listenedGrid');
    listenedGrid.appendChild(wrapper);
  } else {
    toGrid.insertBefore(wrapper, addItem);
  }

  syncListenedSectionVisibility();
}

// ── Checkbox ──────────────────────────────────────
function wireCheckbox(cb, tolistenId, initialListened) {
  // Reflect initial state from API
  if (initialListened) {
    cb.classList.add('checked');
    cb.closest('.tl-item').classList.add('checked');
  }

  cb.addEventListener('click', async () => {
    const wrapper    = cb.closest('.tl-item');
    const nowChecked = !cb.classList.contains('checked'); // what we want to set

    // Optimistic UI update
    cb.classList.toggle('checked', nowChecked);
    wrapper.classList.toggle('checked', nowChecked);

    try {
      const res = await apiFetch(`/api/tolisten/${tolistenId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ listened: nowChecked }),
      });
      if (!res || !res.ok) throw new Error('patch failed');

      // Move between sections after confirmed save
      moveCard(wrapper, nowChecked);

    } catch (err) {
      console.error('Failed to update listened:', err);
      // Revert optimistic update on failure
      cb.classList.toggle('checked', !nowChecked);
      wrapper.classList.toggle('checked', !nowChecked);
    }
  });
}

// ── Build a card from API data ────────────────────
function makeCard(item) {
  const album    = item.Album;
  const note     = item.note || 'added to the list ✓';
  const listened = item.listened;
  const idx      = cardCount % ROTATIONS.length;
  const cardRot  = ROTATIONS[idx];
  const noteRot  = NOTE_ROTATIONS[idx];
  const noteColor = NOTE_COLORS[cardCount % NOTE_COLORS.length];
  cardCount++;

  const wrapper = document.createElement('div');
  wrapper.className = 'tl-item';
  if (listened) wrapper.classList.add('checked');
  wrapper.dataset.id = item.id;

  wrapper.innerHTML = `
    <article class="tl-card" style="--card-rot: ${cardRot}deg;">
      <div class="tl-card-bg" style="transform: rotate(${cardRot}deg);"></div>
      <div class="tl-check-wrap">
        <div class="tl-checkbox${listened ? ' checked' : ''}"></div>
      </div>
      <div class="tl-cover-wrap">
        <img
          src="${escHtml(album.picture)}"
          alt="${escHtml(album.name)}"
          class="tl-cover"
          onerror="this.style.display='none'"
        >
      </div>
      <div class="tl-meta">
        <h3 class="tl-title">${escHtml(album.name)}</h3>
        <p class="tl-artist">${escHtml(album.artist_name)}</p>
      </div>
    </article>
    <div class="sticky-note ${noteColor}" style="transform: rotate(${noteRot}deg);">
      <p>${escHtml(note)}</p>
    </div>
  `;

  wrapper.querySelector('.tl-card').addEventListener('click', (e) => {
    if (e.target.closest('.tl-check-wrap')) return;
    window.location.href = `/albums/${album.id}`;
  });

  wireCheckbox(wrapper.querySelector('.tl-checkbox'), item.id, listened);

  const stickyNote = wrapper.querySelector('.sticky-note');
  stickyNote.style.cursor = 'pointer';
  stickyNote.addEventListener('click', () => openNoteEdit(item.id, item.note, stickyNote));

  return wrapper;
}

// ── Load from API ─────────────────────────────────
async function loadToListen() {
  const grid   = document.getElementById('tolistenGrid');
  const addItem = grid.querySelector('.tl-add-item');

  try {
    const res = await apiFetch('/api/tolisten');
    if (!res) return;
    const data  = await res.json();
    const items = data.ToListen || [];

    // Clear existing cards, keep add button
    grid.innerHTML = '';
    grid.appendChild(addItem);

    // Ensure listened section exists if we'll need it
    const hasListened = items.some(i => i.listened);
    if (hasListened) getOrCreateListenedSection();

    items.forEach(item => {
      const card = makeCard(item);
      if (item.listened) {
        // Goes into listened section
        const listenedGrid = document.getElementById('listenedGrid');
        if (listenedGrid) listenedGrid.appendChild(card);
      } else {
        grid.insertBefore(card, addItem);
      }
    });

    syncListenedSectionVisibility();

  } catch (err) {
    console.error('Failed to load ToListen:', err);
  }
}

// ── Add button ────────────────────────────────────
document.querySelector('.add-btn').addEventListener('click', () => {
  window.location.href = '/search';
});

// ── Note edit popup ───────────────────────────────
function openNoteEdit(tolistenId, currentNote, stickyEl) {
  const existing = document.getElementById('tlPopupOverlay');
  if (existing) existing.remove();

  const overlay = document.createElement('div');
  overlay.id = 'tlPopupOverlay';
  overlay.style.cssText = `
    position:fixed;inset:0;background:rgba(0,0,0,.4);
    z-index:300;display:flex;align-items:center;justify-content:center;
  `;
  overlay.innerHTML = `
    <div class="tl-popup">
      <div class="tl-popup-bg"></div>
      <button class="tl-popup-close" id="tlPopupClose">✕</button>
      <div class="tl-popup-content">
        <h3 class="tl-popup-title">edit note</h3>
        <textarea class="tl-popup-note" id="tlPopupNote"
          rows="3" maxlength="500">${escHtml(currentNote || '')}</textarea>
        <div class="tl-popup-actions">
          <button class="tl-popup-cancel" id="tlPopupCancel">cancel</button>
          <button class="tl-popup-submit" id="tlPopupSubmit">save</button>
        </div>
      </div>
    </div>
  `;
  document.body.appendChild(overlay);

  const textarea = document.getElementById('tlPopupNote');
  textarea.focus();
  textarea.setSelectionRange(textarea.value.length, textarea.value.length);

  const close = () => { overlay.remove(); document.body.style.overflow = ''; };
  document.getElementById('tlPopupClose').addEventListener('click', close);
  document.getElementById('tlPopupCancel').addEventListener('click', close);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });

  document.getElementById('tlPopupSubmit').addEventListener('click', async () => {
    const note = textarea.value.trim();
    const btn  = document.getElementById('tlPopupSubmit');
    btn.textContent = '…'; btn.disabled = true;
    try {
      const res = await apiFetch(`/api/tolisten/${tolistenId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ note }),
      });
      if (!res || !res.ok) throw new Error();
      stickyEl.querySelector('p').textContent = note || 'added to the list ✓';
      close();
    } catch {
      btn.textContent = 'save'; btn.disabled = false;
    }
  });
}

loadToListen();