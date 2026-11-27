# Self-hosted Polis with Ansible

Deploy [Polis](https://github.com/compdemocracy/polis) on one Ubuntu 26.04 (Resolute) amd64 server. Nginx terminates HTTPS, OAuth2 Proxy enforces a Google account allowlist, and Polis runs on internal Docker networks. Conversations, votes, clustering, and standard reports stay on the host. The administrator can associate each vote with the participant’s Google email. Email delivery and AI-generated reports are not configured.

## Deploy

1. Point a public hostname at the server. Allow inbound TCP 80 and 443 for HTTP, HTTPS, and certificate renewal, and allow SSH from your management machine. The server needs outbound access for installation, Google login, and certificate issuance.
2. Install `uv` on your management machine. Copy `inventory.example.ini` to `inventory.ini`, then set the SSH target, public hostname, and initial allowed Google email. Use a login with root or sudo access.
3. Run `./install.sh`. The first run builds the containers, obtains a Let's Encrypt certificate, and creates the credentials directory. Until Google credentials exist, HTTPS serves a placeholder page.
4. In Google Auth Platform, create a **Web application** OAuth client. Register `https://YOUR_HOSTNAME/oauth2/callback` as an authorized redirect URI. Use an External audience to allow accounts outside your Workspace, and add test users if your app is in testing.
5. On the server, create these two root-owned, mode `0600` files under `/etc/oauth2-proxy/credentials/`. Put the single line `OAUTH2_PROXY_CLIENT_ID=YOUR_CLIENT_ID` in `google.env`. Put the client secret value alone in `google-client-secret`.
6. Run `./install.sh` again and open your hostname. To grant or revoke access, edit `/etc/oauth2-proxy/credentials/allowed-emails` on the server (one address per line), then run `systemctl restart polis-oauth2-proxy`. Ansible seeds this file only when it is missing.

Runtime secrets are generated on the host. Keep the inventory, OAuth credentials, private keys, and database backups out of Git. Subsequent runs reuse the database and keys. For playbook validation, run `./install.sh --syntax-check` after creating the inventory.

## Upstream source

The playbook pins the Polis source archive and applies the two patches in `files/polis/` during deployment. They integrate sign-in and sign-out with the Google entrance and bind votes to verified accounts across devices. An incompatible patch fails the run. See the [upstream Polis license](licenses/Polis-LICENSE) for the patched code.
