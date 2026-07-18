(function () {
    const btn = document.getElementById("burgerBtn");
    const nav = document.getElementById("mobileNav");
    const backdrop = document.getElementById("navBackdrop");
    const closeBtn = document.getElementById("navClose");

    if (!btn) return;

    function openNav() {
        btn.classList.add("open");
        nav.classList.add("open");
        document.body.style.overflow = "hidden";
    }

    function closeNav() {
        btn.classList.remove("open");
        nav.classList.remove("open");
        document.body.style.overflow = "";
    }

    btn.addEventListener("click", () =>
        nav.classList.contains("open") ? closeNav() : openNav()
    );

    closeBtn.addEventListener("click", closeNav);
    backdrop.addEventListener("click", closeNav);
})();

import { apiFetch } from "./api.js";
// ───────────────────────────────────────────────
// Escape HTML
// ───────────────────────────────────────────────

function escHtml(str) {
    return String(str)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}


// ───────────────────────────────────────────────
// Genre + Search filters
// ───────────────────────────────────────────────
let activeGenre = 'all';

document.querySelectorAll('.pill').forEach(pill => {
  pill.addEventListener('click', () => {
    document.querySelectorAll('.pill').forEach(p => p.classList.remove('pill-active'));
    pill.classList.add('pill-active');
    activeGenre = pill.dataset.genre;
    applyGenreFilter();
  });
});

function applyGenreFilter() {
  let visible = 0;
  document.querySelectorAll('.album-card').forEach(card => {
    const show = activeGenre === 'all' || card.dataset.genre.includes(activeGenre);
    card.style.display = show ? '' : 'none';
    if (show) visible++;
  });
  document.getElementById('searchNoResults').style.display = visible ? 'none' : 'block';
}

const trigger    = document.getElementById('searchTrigger');
const expand     = document.getElementById('searchExpand');
const searchInput = document.getElementById('searchInput');
const searchClear = document.getElementById('searchClear');

trigger.addEventListener('click', () => {
  expand.classList.add('open');
  trigger.style.display = 'none';
  searchInput.focus();
});

searchInput.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' && searchInput.value.trim()) {
    window.location.href = `/search?q=${encodeURIComponent(searchInput.value.trim())}`;
  }
});

searchInput.addEventListener('input', () => {
  searchClear.style.display = searchInput.value ? 'flex' : 'none';
});

searchClear.addEventListener('click', () => {
  searchInput.value = '';
  searchClear.style.display = 'none';
  expand.classList.remove('open');
  trigger.style.display = '';
});




// ───────────────────────────────────────────────
// Album card
// ───────────────────────────────────────────────

function renderAlbumCard(album) {

    const genres = (album.genres || [])
        .map(g => g.name);

    const searchable = [
        album.name,
        album.artist_name,
        ...genres
    ]
        .join(" ")
        .toLowerCase();

    const card = document.createElement("article");

    card.className = "album-card";

    card.dataset.genre =
        genres.join(" ").toLowerCase();

    card.dataset.searchable = searchable;
    card.style.cursor = 'pointer';
    card.addEventListener('click', () => {
      window.location.href = `/albums/${album.id}`;
    });

    card.innerHTML = `
        <div class="album-card-bg"></div>

        <div class="album-cover-wrap">
            <img
                class="album-thumb"
                src="${escHtml(album.picture)}"
                alt="${escHtml(album.name)}">
        </div>

        <div class="album-info">

            <h3 class="album-title">
                ${escHtml(album.name)}
            </h3>

            <p class="album-artist">
                ${escHtml(album.artist_name)}
            </p>

            <p class="album-year">
                ${escHtml(album.release_date)}
            </p>

            <div class="album-rating">
                <span class="score-star">★</span>

                <span class="album-score">
                    ${album.avg_rating ?? "—"}
                </span>

                <span class="album-count">
                    (${album.rating_count} ratings)
                </span>

            </div>

        </div>
    `;

    return card;
}


// ───────────────────────────────────────────────
// Render sections
// ───────────────────────────────────────────────

function renderPopular(albums) {

    const grid = document.getElementById("popularGrid");

    grid.innerHTML = "";

    albums.forEach(album =>
        grid.appendChild(renderAlbumCard(album))
    );

}

function renderRecommendations(albums) {

    const grid = document.getElementById("recommendGrid");

    grid.innerHTML = "";

    albums.forEach(album =>
        grid.appendChild(renderAlbumCard(album))
    );

}


// ───────────────────────────────────────────────
// Load page
// ───────────────────────────────────────────────

async function loadExplore() {

    try {

        const res = await apiFetch("api/explore");

        if (!res.ok)
            throw new Error("API error");

        const data = await res.json();

        document.getElementById("popularLoading")?.remove();
        document.getElementById("recommendLoading")?.remove();

        renderPopular(data.Popular);

        renderRecommendations(data.Recommendations);


    }

    catch (err) {

        console.error(err);

        document.getElementById("popularLoading").textContent =
            "Couldn't load albums.";

        document.getElementById("recommendLoading").textContent =
            "Couldn't load recommendations.";

    }

}
import { updateNav } from './navbar.js';

updateNav();

loadExplore();