import { apiFetch } from "./api.js";

// ── Burger menu ───────────────────────────────────
(function () {
  var btn = document.getElementById('burgerBtn');
  var nav = document.getElementById('mobileNav');
  var backdrop = document.getElementById('navBackdrop');
  var closeBtn = document.getElementById('navClose');
  if (!btn) return;
  function openNav() { btn.classList.add('open'); nav.classList.add('open'); document.body.style.overflow = 'hidden'; }
  function closeNav() { btn.classList.remove('open'); nav.classList.remove('open'); document.body.style.overflow = ''; }
  btn.addEventListener('click', function () { nav.classList.contains('open') ? closeNav() : openNav(); });
  closeBtn.addEventListener('click', closeNav);
  backdrop.addEventListener('click', closeNav);
})();

export function redirectIfLoggedIn() {
    const token = localStorage.getItem('access_token');
    const authPaths = ['/users/login', '/users/register', '/users'];
    if (token && authPaths.includes(location.pathname)) {
        window.location.replace('/explore');
    }
}



// ── Show/hide password ────────────────────────────
const togglePw = document.getElementById('togglePw');
const pwField  = document.getElementById('password');

if (togglePw && pwField) {
  togglePw.addEventListener('click', () => {
    const isText = pwField.type === 'text';
    pwField.type = isText ? 'password' : 'text';
    togglePw.textContent = isText ? '👁' : '🙈';
  });
}

// ── Register: password match check ───────────────
const pw2Field  = document.getElementById('password2');
const mismatch  = document.getElementById('pwMismatch');
const submitBtn = document.getElementById('registerSubmit');

if (pw2Field && mismatch && submitBtn) {
  function checkMatch() {
    const noMatch = pwField.value && pw2Field.value && pwField.value !== pw2Field.value;
    mismatch.style.display  = noMatch ? 'block' : 'none';
    submitBtn.disabled      = !!noMatch;
  }
  pw2Field.addEventListener('input', checkMatch);
  pwField.addEventListener('input', checkMatch);
}


async function registerUser(e) {
  e.preventDefault();

  if (pwField.value !== pw2Field.value) {
    mismatch.style.display = "block";
    return;
  }

  const body = {
    name: document.getElementById("name").value,
    email: document.getElementById("email").value,
    password: document.getElementById("password").value,
    age: Number(document.getElementById("age").value) || null,
    gender: document.getElementById("gender").value,
    location: document.getElementById("location").value || null
  };

  try {
    const res = await fetch("/api/users", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(body)
    });

    const data = await res.json();

    if (!res.ok) {
      alert(data.message || data.error || "Registration failed.");
      return;
    }

    alert("Account created!");
    window.location.href = "users/login";
  }
  catch (err) {
    console.error(err);
    alert("Couldn't connect to the server.");
  }
}


const registerForm = document.getElementById("registerForm");

if (registerForm) {
  registerForm.addEventListener("submit", registerUser);
}


const loginForm = document.getElementById("loginForm");

if (loginForm) {
    loginForm.addEventListener("submit", async (e) => {
        e.preventDefault();

        const res = await fetch("/api/users/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                email: document.getElementById("email").value,
                password: document.getElementById("password").value
            })
        });

        const data = await res.json();

        if (res.ok) {
            localStorage.setItem("access_token", data.tokens.access);
            localStorage.setItem("refresh_token", data.tokens.refresh);
            localStorage.setItem("user_id", data.user_id);
            window.location.href = "/explore";
        } else {
            alert(data.message || "Login failed");
        }
    });
}

redirectIfLoggedIn();