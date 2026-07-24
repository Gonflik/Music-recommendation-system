// tolistenPopup.js
import { apiFetch } from './api.js';

export function openToListenPopup(albumId, albumName, onSuccess) {
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
        <h3 class="tl-popup-title">add to ToListen</h3>
        <p class="tl-popup-subtitle">${albumName}</p>
        <textarea class="tl-popup-note" id="tlPopupNote"
          placeholder="why do you want to listen to this?… (optional)"
          rows="3" maxlength="500"></textarea>
        <div class="tl-popup-actions">
          <button class="tl-popup-cancel" id="tlPopupCancel">cancel</button>
          <button class="tl-popup-submit" id="tlPopupSubmit">save it ✓</button>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(overlay);
  document.getElementById('tlPopupNote').focus();

  const close = () => { overlay.remove(); document.body.style.overflow = ''; };
  document.getElementById('tlPopupClose').addEventListener('click', close);
  document.getElementById('tlPopupCancel').addEventListener('click', close);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });

  document.getElementById('tlPopupSubmit').addEventListener('click', async () => {
    const note = document.getElementById('tlPopupNote').value.trim();
    const btn = document.getElementById('tlPopupSubmit');
    btn.textContent = '…'; btn.disabled = true;
    try {
      const res = await apiFetch('/api/tolisten', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ album_id: albumId, note }),
      });
      if (!res || !res.ok) throw new Error();
      close();
      onSuccess(note);
    } catch {
      btn.textContent = 'save it ✓'; btn.disabled = false;
    }
  });
}