// ── Shared preview player ─────────────────────────
const audio = new Audio();
let activeBtn = null;

export function playPreview(previewUrl, btnEl) {
  if (activeBtn === btnEl) {
    if (audio.paused) {
      audio.play();
      btnEl.classList.add('playing');
    } else {
      audio.pause();
      btnEl.classList.remove('playing');
    }
    return;
  }

  stopPreview();

  audio.src = previewUrl;
  audio.play().catch(() => {});
  activeBtn = btnEl;
  btnEl.classList.add('playing');

  audio.onended = () => {
    btnEl.classList.remove('playing');
    activeBtn = null;
  };
}

export function stopPreview() {
  if (activeBtn) {
    activeBtn.classList.remove('playing');
    activeBtn = null;
  }
  audio.pause();
  audio.src = '';
}

// ── Build a play button element ───────────────────
export function makePlayBtn(songId) {  // takes songId now, not URL
  const btn = document.createElement('button');
  btn.className = 'preview-btn';
  btn.title = 'preview';

  const triangle = document.createElement('span');
  triangle.className = 'preview-triangle';
  triangle.textContent = '▶';

  const pause = document.createElement('div');
  pause.className = 'preview-pause';

  btn.appendChild(triangle);
  btn.appendChild(pause);

  btn.addEventListener('click', async (e) => {
    e.stopPropagation();

    // if already loaded, just toggle
    if (btn.dataset.previewUrl) {
      playPreview(btn.dataset.previewUrl, btn);
      return;
    }

    // lazy fetch
    btn.classList.add('loading');
    try {
      const res = await fetch(`/api/songs/${songId}/preview`, {
        headers: { Authorization: `Bearer ${localStorage.getItem('access_token')}` }
      });
      if (!res.ok) throw new Error();
      const data = await res.json();
      btn.dataset.previewUrl = data.preview_url;
      playPreview(data.preview_url, btn);
    } catch {
      console.error('Could not load preview');
    } finally {
      btn.classList.remove('loading');
    }
  });

  return btn;
}