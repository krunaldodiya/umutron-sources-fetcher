-- ============================================================================
-- UmuTron Sources Seeder
-- Seeds all 24 catalog sources with direct GitHub Raw Usercontent URLs
-- from github.com/krunaldodiya/umutron-sources-fetcher.
--
-- Safe to run in Turso Web Console or via:
--   turso db shell <database_name> < seed-sources.sql
-- ============================================================================

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  url TEXT NOT NULL UNIQUE,
  is_protected INTEGER DEFAULT 0,
  enabled INTEGER DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  trust_status TEXT
);

INSERT INTO sources (id, name, url, is_protected, enabled, created_at, updated_at)
VALUES
  ('fitgirl', 'FitGirl', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/fitgirl.json', 0, 1, datetime('now'), datetime('now')),
  ('byxatab', 'ByXatab', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/xatab.json', 0, 0, datetime('now'), datetime('now')),
  ('dodi', 'DODI', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/dodi.json', 0, 0, datetime('now'), datetime('now')),
  ('online_fix', 'Online-Fix', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/onlinefix.json', 0, 0, datetime('now'), datetime('now')),
  ('empress', 'Empress', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/empress.json', 0, 0, datetime('now'), datetime('now')),
  ('free_gog', 'Free GOG', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/gog.json', 0, 0, datetime('now'), datetime('now')),
  ('kaoskrew', 'KaOsKrew', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/kaoskrew.json', 0, 0, datetime('now'), datetime('now')),
  ('tiny_repacks', 'Tiny-Repacks', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/tinyrepacks.json', 0, 0, datetime('now'), datetime('now')),
  ('steamrip', 'SteamRip', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/steamrip.json', 0, 0, datetime('now'), datetime('now')),
  ('atopgames', 'AtopGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/atop-games.json', 0, 0, datetime('now'), datetime('now')),
  ('rexagames', 'RexaGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rexagames.json', 0, 0, datetime('now'), datetime('now')),
  ('psxroms', 'PsxRoms', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/psx-roms.json', 0, 0, datetime('now'), datetime('now')),
  ('david_kazumi', 'David Kazumi', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/fontekazumi.json', 0, 0, datetime('now'), datetime('now')),
  ('steamgg', 'SteamGG', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/steamgg.json', 0, 0, datetime('now'), datetime('now')),
  ('redump', 'Redump', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/redump.json', 0, 0, datetime('now'), datetime('now')),
  ('ps1_ps3_rutracker', 'PS1-PS3 Rutracker', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rt_ps.json', 0, 0, datetime('now'), datetime('now')),
  ('rutracker_rutor', 'Rutracker & Rutor', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rutor.json', 0, 0, datetime('now'), datetime('now')),
  ('retroarch_games', 'RetroArch Games', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/no-intro.json', 0, 0, datetime('now'), datetime('now')),
  ('shisuy_source', "Shisuy's Source", 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/shisuyssource.json', 0, 0, datetime('now'), datetime('now')),
  ('hydrasources_freetp', 'HydraSources | FreeTp.Org', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/freetp_games.json', 0, 0, datetime('now'), datetime('now')),
  ('ankergames', 'AnkerGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/ankergames.json', 0, 0, datetime('now'), datetime('now')),
  ('hydrasources_nnmclub', 'HydraSources.su | nnmclub', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/nnmclub.json', 0, 0, datetime('now'), datetime('now')),
  ('hydrasources_russian', 'HydraSources(RUSSIAN)', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/hydra.json', 0, 0, datetime('now'), datetime('now')),
  ('anti_denuvo', 'Anti-Denuvo Sanctuary', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/source.json', 0, 0, datetime('now'), datetime('now'))
ON CONFLICT(id) DO UPDATE SET
  name = excluded.name,
  url = excluded.url,
  is_protected = excluded.is_protected,
  updated_at = excluded.updated_at;
