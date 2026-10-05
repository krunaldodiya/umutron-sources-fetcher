#!/usr/bin/env python3
"""
UmuTron Sources Fetcher
Downloads catalog source feeds (resolving Cloudflare Turnstile with SeleniumBase UC),
saves them into sources/, and automatically commits & pushes to GitHub.
"""

import argparse
import json
import os
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse

def log(msg: str):
    timestamp = datetime.now(timezone.utc).strftime("%H:%M:%S")
    print(f"[{timestamp}] {msg}", flush=True)

def load_sources_registry(repo_dir: Path) -> list[dict]:
    sources_file = repo_dir / "sources.json"
    if sources_file.exists():
        try:
            with open(sources_file, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            log(f"Warning: Failed to read {sources_file}: {e}")
    return []

def export_sources_from_turso(repo_dir: Path) -> list[dict]:
    """Query the Turso database to refresh sources.json if turso CLI is available."""
    sql = """
    SELECT json_group_array(
        json_object(
            'source_id', id,
            'source_name', name,
            'url', url,
            'is_protected', is_protected,
            'enabled', enabled
        )
    ) FROM sources ORDER BY id;
    """
    try:
        cmd = ["turso", "db", "shell", "emutronlinks", sql]
        raw = subprocess.check_output(cmd, text=True)
        for line in raw.splitlines():
            line = line.strip()
            if line.startswith("[") and line.endswith("]"):
                data = json.loads(line)
                sources_file = repo_dir / "sources.json"
                with open(sources_file, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2)
                log(f"Exported {len(data)} sources from Turso to sources.json")
                return data
    except Exception as e:
        log(f"Notice: Turso sources export skipped ({e}). Using existing sources.json.")
    return []

def get_source_filename(source_info: dict) -> str:
    url = source_info.get("url", "")
    raw_name = url.rstrip("/").split("/")[-1].split("?")[0]
    if raw_name.endswith(".json"):
        return raw_name
    sid = source_info.get("source_id", "source")
    return f"{sid}.json"

def fetch_source_json(source_info: dict, shared_driver=None) -> tuple[bytes, dict]:
    url = source_info["url"]
    name = source_info.get("source_name", "Unknown")
    log(f"Fetching '{name}' from {url}...")
    from curl_cffi import requests

    # 1. Fast direct fetch attempt
    try:
        r = requests.get(url, impersonate="chrome124", timeout=15)
        if r.status_code == 200:
            try:
                data = json.loads(r.content)
                log(f"Direct fetch succeeded (HTTP 200, {round(len(r.content)/1024, 1)} KB)")
                return r.content, data
            except Exception:
                pass
        log(f"Direct fetch returned HTTP {r.status_code}; Cloudflare Turnstile detected.")
    except Exception as e:
        log(f"Direct fetch exception: {e}")

    # 2. SeleniumBase Undetected-ChromeDriver challenge resolution
    log(f"Launching SeleniumBase Undetected-ChromeDriver for '{name}'...")
    from seleniumbase import Driver
    driver = shared_driver or Driver(uc=True, headless2=True)
    should_quit = shared_driver is None
    try:
        driver.uc_open_with_reconnect(url, reconnect_time=6)
        cookies = {}
        start_time = time.time()
        while time.time() - start_time < 20:
            cookies = {c["name"]: c["value"] for c in driver.get_cookies()}
            if "cf_clearance" in cookies:
                elapsed = round(time.time() - start_time, 2)
                log(f"Cloudflare Turnstile clearance obtained in {elapsed}s")
                break
            time.sleep(1)

        ua = driver.execute_script("return navigator.userAgent;")
        sess = requests.Session(impersonate="chrome124")
        sess.cookies.update(cookies)
        sess.headers.update({"User-Agent": ua})

        log("Downloading full JSON payload with clearance session...")
        r = sess.get(url, timeout=45)
        if r.status_code != 200:
            raise RuntimeError(f"HTTP {r.status_code} received from {url}")

        data = json.loads(r.content)
        log(f"Successfully downloaded {round(len(r.content)/1024, 1)} KB JSON for '{name}'")
        return r.content, data
    finally:
        if should_quit:
            driver.quit()

def git_commit_and_push(file_paths: list[Path], summary_msg: str, repo_dir: Path):
    log("Staging updated files in git...")
    for fp in file_paths:
        if fp.exists():
            subprocess.run(["git", "add", str(fp.relative_to(repo_dir))], cwd=repo_dir, check=True)

    # Check if there are staged changes
    diff_res = subprocess.run(["git", "diff", "--cached", "--quiet"], cwd=repo_dir)
    if diff_res.returncode == 0:
        log("No changes detected. Catalog is already up to date on GitHub.")
        return False

    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    commit_msg = f"{summary_msg} ({timestamp})"
    log(f"Committing: '{commit_msg}'...")
    subprocess.run(["git", "commit", "-m", commit_msg], cwd=repo_dir, check=True)

    log("Pushing commit to GitHub...")
    subprocess.run(["git", "push", "origin", "main"], cwd=repo_dir, check=True)
    log("Push complete!")
    return True

def process_source(source_info: dict, output_dir: Path, repo_dir: Path, no_push: bool, shared_driver=None) -> Path:
    name = source_info.get("source_name", "Unknown")
    raw_bytes, data = fetch_source_json(source_info, shared_driver=shared_driver)

    downloads = data.get("downloads", []) if isinstance(data, dict) else data if isinstance(data, list) else []
    count = len(downloads)
    log(f"Valid catalog JSON: {count} releases found for '{name}'")

    filename = get_source_filename(source_info)
    out_file = output_dir / filename
    out_file.write_bytes(raw_bytes)
    log(f"Saved payload to: {out_file}")

    raw_url = f"https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/{filename}"
    log(f"Raw GitHub Usercontent URL: {raw_url}")
    print(f"Result: {name} -> {raw_url} ({count} releases)")
    return out_file

def main():
    parser = argparse.ArgumentParser(description="Download catalog sources through Cloudflare and push to GitHub")
    parser.add_argument(
        "--source",
        type=str,
        default="fitgirl",
        help="Source ID or name to fetch (e.g. 'fitgirl', 'dodi', or 'all'). Default: 'fitgirl'",
    )
    parser.add_argument(
        "--refresh-sources",
        action="store_true",
        help="Export fresh list of sources from Turso database to sources.json",
    )
    parser.add_argument(
        "--no-push",
        action="store_true",
        help="Download and save locally only, do not git push",
    )
    args = parser.parse_args()

    repo_dir = Path(__file__).resolve().parent
    if args.refresh_sources or not (repo_dir / "sources.json").exists():
        export_sources_from_turso(repo_dir)

    sources_list = load_sources_registry(repo_dir)
    if not sources_list:
        sources_list = export_sources_from_turso(repo_dir)

    if not sources_list:
        print("Error: No sources found in sources.json or Turso database.", file=sys.stderr)
        sys.exit(1)

    sources_dir = repo_dir / "sources"
    sources_dir.mkdir(parents=True, exist_ok=True)

    selected_key = args.source.strip().lower()
    if selected_key == "all":
        targets = sources_list
    else:
        matched = [
            s for s in sources_list
            if s.get("source_id", "").lower() == selected_key
            or s.get("source_name", "").lower() == selected_key
            or s.get("source_id", "").lower().replace("_", "") == selected_key.replace("_", "")
        ]
        if not matched:
            print(f"Error: Unknown source '{args.source}'. Available in sources.json: {[s.get('source_id') for s in sources_list]}", file=sys.stderr)
            sys.exit(1)
        targets = matched

    log(f"Starting fetch for {len(targets)} source(s): {[s.get('source_name') for s in targets]}")
    saved_files = []
    
    for s_info in targets:
        try:
            saved_file = process_source(s_info, sources_dir, repo_dir, args.no_push)
            saved_files.append(saved_file)
        except Exception as e:
            log(f"Error processing '{s_info.get('source_name')}': {e}")

    if not args.no_push and saved_files:
        sources_json_file = repo_dir / "sources.json"
        staged = list(saved_files)
        if sources_json_file.exists():
            staged.append(sources_json_file)
        
        if len(targets) == 1:
            summary = f"Update {targets[0].get('source_name')}"
        else:
            summary = f"Update {len(saved_files)} catalog sources"
        
        git_commit_and_push(staged, summary, repo_dir)

if __name__ == "__main__":
    main()
