(() => {
  const key = `polis.google.user:${location.origin}/identity:polis`
  const user = JSON.parse(localStorage.getItem(key))
  let redirecting = false

  function signIn() {
    if (redirecting) return
    redirecting = true
    sessionStorage.setItem('polis.voterReturnTo', location.href)
    localStorage.removeItem(key)
    location.replace('/signin')
  }

  window.polisVoterToken = () => {
    if (!user?.access_token || !(user.expires_at > Date.now() / 1000)) signIn()
    return redirecting ? null : user.access_token
  }

  if (window.polisVoterToken()) {
    fetch('/oauth2/userinfo', { cache: 'no-store' })
      .then(response => response.ok ? response.json() : null)
      .then(session => {
        if (!session?.user || session.user !== user.profile?.federated_claims?.user_id ||
            session.email !== user.profile?.email) signIn()
      })
      .catch(() => console.error('Could not check the current Google login.'))
  }
})()
