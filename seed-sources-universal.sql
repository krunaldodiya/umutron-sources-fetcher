-- ============================================================================
-- Universal ANSI-SQL Seeder (Works on SQLite, Turso, PostgreSQL & MySQL)
-- ============================================================================

CREATE TABLE IF NOT EXISTS sources (
  id VARCHAR(128) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  url VARCHAR(2048) NOT NULL UNIQUE,
  is_protected INT DEFAULT 0,
  enabled INT DEFAULT 1,
  created_at VARCHAR(64) NOT NULL,
  updated_at VARCHAR(64) NOT NULL,
  trust_status VARCHAR(64)
);

DELETE FROM sources;

INSERT INTO sources (id, name, url, is_protected, enabled, created_at, updated_at)
VALUES
  ('fitgirl', 'FitGirl', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/fitgirl.json', 0, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('byxatab', 'ByXatab', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/xatab.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('dodi', 'DODI', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/dodi.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('online_fix', 'Online-Fix', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/onlinefix.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('empress', 'Empress', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/empress.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('free_gog', 'Free GOG', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/gog.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('kaoskrew', 'KaOsKrew', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/kaoskrew.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('tiny_repacks', 'Tiny-Repacks', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/tinyrepacks.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('steamrip', 'SteamRip', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/steamrip.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('atopgames', 'AtopGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/atop-games.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('rexagames', 'RexaGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rexagames.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('psxroms', 'PsxRoms', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/psx-roms.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('david_kazumi', 'David Kazumi', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/fontekazumi.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('steamgg', 'SteamGG', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/steamgg.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('redump', 'Redump', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/redump.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('ps1_ps3_rutracker', 'PS1-PS3 Rutracker', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rt_ps.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('rutracker_rutor', 'Rutracker & Rutor', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/rutor.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('retroarch_games', 'RetroArch Games', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/no-intro.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('shisuy_source', "Shisuy's Source", 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/shisuyssource.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('hydrasources_freetp', 'HydraSources | FreeTp.Org', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/freetp_games.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('ankergames', 'AnkerGames', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/ankergames.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('hydrasources_nnmclub', 'HydraSources.su | nnmclub', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/nnmclub.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('hydrasources_russian', 'HydraSources(RUSSIAN)', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/hydra.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('anti_denuvo', 'Anti-Denuvo Sanctuary', 'https://raw.githubusercontent.com/krunaldodiya/umutron-sources-fetcher/main/sources/source.json', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
