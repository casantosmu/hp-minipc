# Home Server

Infrastructure-as-code for a personal media server running on an HP Mini PC.

Docker Compose runs Jellyfin, Sonarr, Radarr, qBittorrent, Soulseek, Syncthing and a small Homer dashboard. Downloads are routed through Proton VPN, while Caddy exposes Jellyfin over HTTPS.

The repository also contains lightweight Bash automation for backups, dynamic DNS and service health checks. Persistent data and secrets are intentionally excluded from Git.
