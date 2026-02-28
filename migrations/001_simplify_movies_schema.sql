-- Migration: simplify movies schema to only (id, title)
--
-- This script is safe to run multiple times. It checks whether the existing
-- `movies` table contains any of the columns `director`, `year`, or `rating`.
-- If none are present, the script exits without making changes. If any are
-- present it will:
--   1. Create a temporary table `movies_new` with the simplified schema
--      (id BIGSERIAL PRIMARY KEY, title TEXT NOT NULL).
--   2. Copy id/title from the old `movies` table into `movies_new` (preserving ids).
--   3. Set the sequence value for the new table to MAX(id).
--   4. Drop the old `movies` table and rename `movies_new` -> `movies`.
--
-- IMPORTANT: This operation will DROP the old table once data is copied.
-- Make a backup before running this script if you care about the extra columns.

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'movies' AND column_name IN ('director','year','rating')
    ) THEN
        RAISE NOTICE 'Starting migration: simplifying movies table schema';

        CREATE TABLE IF NOT EXISTS movies_new (
            id BIGSERIAL PRIMARY KEY,
            title TEXT NOT NULL
        );

        -- Copy id/title preserving existing ids. ON CONFLICT prevents duplicates
        -- if the script is re-run.
        INSERT INTO movies_new (id, title)
        SELECT id, title FROM movies
        ON CONFLICT (id) DO NOTHING;

        -- Ensure the sequence for movies_new.id is set to the current max
        PERFORM setval(pg_get_serial_sequence('movies_new','id'), COALESCE((SELECT max(id) FROM movies_new),0), true);

        -- Replace old table with the new one
        DROP TABLE movies;
        ALTER TABLE movies_new RENAME TO movies;

        RAISE NOTICE 'Migration complete: movies table now has columns (id, title)';
    ELSE
        RAISE NOTICE 'Migration not required: movies table already has simplified schema';
    END IF;
END$$;

