# UmuTron Sources Fetcher

Automated source catalog downloader and GitHub mirror for UmuTron. Resolves Cloudflare Turnstile protected sources using SeleniumBase Undetected-ChromeDriver, validates feeds, and mirrors fresh JSON payloads to GitHub for clean, unblocked consumption by the UmuTron Next.js API.

## Features
- **Cloudflare Turnstile Bypass**: Automatically detects Cloudflare challenges and resolves them via SeleniumBase Undetected-ChromeDriver.
- **Single-Command Pipeline**: Automatically fetches, validates, commits, and pushes to GitHub in one run.
- **Selective Syncing**: Use `--source <name>` (e.g. `--source fitgirl`) to update individual sources without the heavy workload of syncing all at once.
- **All 24 Sources Registry**: Maintains `sources.json` with all 24 catalog sources exported from the database.
- **Pure Python & uv**: Managed entirely with `uv` without shell scripts.

## Installation

```bash
uv sync
```

## Usage

### Fetch and push a specific source (e.g. FitGirl)
```bash
uv run python main.py --source fitgirl
```

### Fetch all 24 sources
```bash
uv run python main.py --source all
```

### Refresh sources.json from Turso database
```bash
uv run python main.py --refresh-sources
```

### Local download only (skip git push)
```bash
uv run python main.py --source fitgirl --no-push
```

## Raw GitHub Feed URLs

- **FitGirl**: `https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/fitgirl.json`
- **All Sources List**: `https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources.json`
