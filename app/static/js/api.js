export async function apiFetch(url, options = {}) {
    let accessToken = localStorage.getItem("access_token");

    options.headers = {
        ...options.headers,
        Authorization: `Bearer ${accessToken}`,
    };

    let res = await fetch(url, options);

    if (res.status === 401) {
        const refreshed = await refreshAccessToken();

        if (!refreshed) {
            window.location.href = "users/login";
            return;
        }

        accessToken = localStorage.getItem("access_token");
        options.headers.Authorization = `Bearer ${accessToken}`;

        res = await fetch(url, options);
    }

    return res;
}

async function refreshAccessToken() {
    const refreshToken = localStorage.getItem("refresh_token");

    const res = await fetch("/refresh", {
        method: "GET",
        headers: {
            Authorization: `Bearer ${refreshToken}`
        }
    });

    if (!res.ok)
        return false;

    const data = await res.json();
    localStorage.setItem("access_token", data.access_token);
    return true;
}


