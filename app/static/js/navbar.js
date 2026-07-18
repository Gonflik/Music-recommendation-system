// ── Auth nav ──────────────────────────────────────
export function updateNav() {
  const loggedIn = !!localStorage.getItem('access_token');
  const userId = localStorage.getItem('user_id');
  const profileHref = userId ? `/users/${userId}` : '/users/login';

  // desktop nav
  document.querySelector('.nav-right').innerHTML = loggedIn
    ? `<a href="${profileHref}" class="nav-link gradient-text">Profile</a>
       <a href="#" class="nav-link" id="logoutBtn">Log Out</a>`
    : `<a href="/users/login" class="nav-link">Log In</a>
       <a href="/users" class="nav-link">Sign Up</a>`;

  // mobile nav auth
  document.querySelector('.mobile-nav-auth').innerHTML = loggedIn
    ? `<a href="${profileHref}" class="mobile-nav-auth-link">Profile</a>
       <a href="#" class="mobile-nav-auth-link" id="logoutBtnMobile">Log Out</a>`
    : `<a href="/users/login" class="mobile-nav-auth-link">Log In</a>
       <a href="/users" class="mobile-nav-auth-link">Sign Up</a>`;

  if (loggedIn) {
    document.getElementById('logoutBtn')?.addEventListener('click', logout);
    document.getElementById('logoutBtnMobile')?.addEventListener('click', logout);
  }
}

export function logout() {
  localStorage.removeItem('access_token');
  localStorage.removeItem('refresh_token');
  localStorage.removeItem('user_id');
  window.location.href = '/';
}

updateNav();