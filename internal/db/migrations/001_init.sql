-- Ensure required extension for gen_random_uuid() if you use UUID defaults.
-- CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS "categories" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "created_at" timestamptz DEFAULT now(),
  CONSTRAINT categories_name_unique UNIQUE ("name")
);

CREATE TABLE IF NOT EXISTS "movies" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "title" text NOT NULL,
  "created_at" timestamptz DEFAULT now(),
  CONSTRAINT movies_title_unique UNIQUE ("title")
);

-- 1) Ensure nominees table exists
CREATE TABLE IF NOT EXISTS "nominees" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "movie_id" uuid NOT NULL,
  "category_id" uuid NOT NULL,
  "nominee_name" text,
  "created_at" timestamptz DEFAULT now(),
  UNIQUE ("movie_id", "category_id", "nominee_name")
);

-- Conditionally add FK constraints if referenced tables/columns exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fk_nominees_movie'
  ) THEN
    BEGIN
      ALTER TABLE "nominees"
        ADD CONSTRAINT fk_nominees_movie
        FOREIGN KEY ("movie_id") REFERENCES "movies"("id") ON DELETE CASCADE;
    EXCEPTION WHEN undefined_table OR undefined_column THEN
      RAISE NOTICE 'Skipping FK to movies: table/column not found or incompatible.';
    END;
  END IF;
END;
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fk_nominees_category'
  ) THEN
    BEGIN
      ALTER TABLE "nominees"
        ADD CONSTRAINT fk_nominees_category
        FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE CASCADE;
    EXCEPTION WHEN undefined_table OR undefined_column THEN
      RAISE NOTICE 'Skipping FK to categories: table/column not found or incompatible.';
    END;
  END IF;
END;
$$;

-- 2) Upsert categories by name
INSERT INTO "categories" ("name")
VALUES
  ('Best Picture'),
  ('Best Actor'),
  ('Best Actress'),
  ('Best Supporting Actor'),
  ('Best Supporting Actress'),
  ('Best Director'),
  ('Best Animated Feature Film'),
  ('Best Animated Short Film'),
  ('Best Documentary Feature Film'),
  ('Best Documentary Short Film'),
  ('Best Live Action Short Film'),
  ('Best Casting'),
  ('Best Cinematography'),
  ('Best Costume Design'),
  ('Best Film Editing'),
  ('Best International Feature Film'),
  ('Best Makeup and Hairstyling')
ON CONFLICT ("name") DO NOTHING;

-- 3) Upsert movies by title
INSERT INTO "movies" ("title")
VALUES
  ('Bugonia'),
  ('F1'),
  ('Frankenstein'),
  ('Hamnet'),
  ('Marty Supreme'),
  ('One Battle After Another'),
  ('The Secret Agent'),
  ('Sentimental Value'),
  ('Sinners'),
  ('Train Dreams'),
  ('Blue Moon'),
  ('If I Had Legs I''d Kick You'),
  ('Song Sung Blue'),
  ('Weapons'),
  ('Arco'),
  ('Elio'),
  ('KPop Demon Hunters'),
  ('Little Amélie or the Character of Rain'),
  ('Zootopia 2'),
  ('Butterfly'),
  ('Forevergreen'),
  ('The Girl Who Cried Pearls'),
  ('Retirement Plan'),
  ('The Three Sisters'),
  ('The Alabama Solution'),
  ('Come See Me in the Good Light'),
  ('Cutting Through Rocks'),
  ('Mr. Nobody Against Putin'),
  ('The Perfect Neighbor'),
  ('All the Empty Rooms'),
  ('Armed Only with a Camera: The Life and Death of Brent Renaud'),
  ('Children No More: "Were and Are Gone"'),
  ('The Devil Is Busy'),
  ('Perfectly a Strangeness'),
  ('Butcher''s Stain'),
  ('A Friend of Dorothy'),
  ('Jane Austen''s Period Drama'),
  ('The Singers'),
  ('Two People Exchanging Saliva'),
  ('Avatar: Fire and Ash'),
  ('Kokuho'),
  ('The Smashing Machine'),
  ('The Ugly Stepsister'),
  ('It Was Just an Accident'),
  ('Sirāt'),
  ('The Voice of Hind Rajab')
ON CONFLICT ("title") DO NOTHING;

-- 4) Insert nominations for each category by lookup

-- Best Picture
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Picture'
WHERE m.title IN (
  'Bugonia','F1','Frankenstein','Hamnet','Marty Supreme','One Battle After Another','The Secret Agent','Sentimental Value','Sinners','Train Dreams'
)
ON CONFLICT DO NOTHING;

-- Best Actor
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Timothée Chalamet – Marty Supreme','Marty Supreme'),
    ('Leonardo DiCaprio – One Battle After Another','One Battle After Another'),
    ('Ethan Hawke – Blue Moon','Blue Moon'),
    ('Michael B. Jordan – Sinners','Sinners'),
    ('Wagner Moura – The Secret Agent','The Secret Agent')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Actor'
ON CONFLICT DO NOTHING;

-- Best Actress
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Jessie Buckley – Hamnet','Hamnet'),
    ('Rose Byrne – If I Had Legs I''d Kick You','If I Had Legs I''d Kick You'),
    ('Kate Hudson – Song Sung Blue','Song Sung Blue'),
    ('Renate Reinsve – Sentimental Value','Sentimental Value'),
    ('Emma Stone – Bugonia','Bugonia')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Actress'
ON CONFLICT DO NOTHING;

-- Best Supporting Actor
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Benicio Del Toro – One Battle After Another','One Battle After Another'),
    ('Jacob Elordi – Frankenstein','Frankenstein'),
    ('Delroy Lindo – Sinners','Sinners'),
    ('Sean Penn – One Battle After Another','One Battle After Another'),
    ('Stellan Skarsgård – Sentimental Value','Sentimental Value')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Supporting Actor'
ON CONFLICT DO NOTHING;

-- Best Supporting Actress
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Elle Fanning – Sentimental Value','Sentimental Value'),
    ('Inga Ibsdotter Lilleaas – Sentimental Value','Sentimental Value'),
    ('Amy Madigan – Weapons','Weapons'),
    ('Wunmi Mosaku – Sinners','Sinners'),
    ('Teyana Taylor – One Battle After Another','One Battle After Another')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Supporting Actress'
ON CONFLICT DO NOTHING;

-- Best Director
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Chloé Zhao – Hamnet','Hamnet'),
    ('Josh Safdie – Marty Supreme','Marty Supreme'),
    ('Paul Thomas Anderson – One Battle After Another','One Battle After Another'),
    ('Joachim Trier – Sentimental Value','Sentimental Value'),
    ('Ryan Coogler – Sinners','Sinners')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Director'
ON CONFLICT DO NOTHING;

-- Best Animated Feature Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Animated Feature Film'
WHERE m.title IN ('Arco','Elio','KPop Demon Hunters','Little Amélie or the Character of Rain','Zootopia 2')
ON CONFLICT DO NOTHING;

-- Best Animated Short Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Animated Short Film'
WHERE m.title IN ('Butterfly','Forevergreen','The Girl Who Cried Pearls','Retirement Plan','The Three Sisters')
ON CONFLICT DO NOTHING;

-- Best Documentary Feature Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Documentary Feature Film'
WHERE m.title IN ('The Alabama Solution','Come See Me in the Good Light','Cutting Through Rocks','Mr. Nobody Against Putin','The Perfect Neighbor')
ON CONFLICT DO NOTHING;

-- Best Documentary Short Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Documentary Short Film'
WHERE m.title IN (
  'All the Empty Rooms',
  'Armed Only with a Camera: The Life and Death of Brent Renaud',
  'Children No More: "Were and Are Gone"',
  'The Devil Is Busy',
  'Perfectly a Strangeness'
)
ON CONFLICT DO NOTHING;

-- Best Live Action Short Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best Live Action Short Film'
WHERE m.title IN ('Butcher''s Stain','A Friend of Dorothy','Jane Austen''s Period Drama','The Singers','Two People Exchanging Saliva')
ON CONFLICT DO NOTHING;

-- Best Casting
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Hamnet – Nina Gold','Hamnet'),
    ('Marty Supreme – Jennifer Venditti','Marty Supreme'),
    ('One Battle After Another – Cassandra Kulukundis','One Battle After Another'),
    ('The Secret Agent – Gabriel Domingues','The Secret Agent'),
    ('Sinners – Francine Maisler','Sinners')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Casting'
ON CONFLICT DO NOTHING;

-- Best Cinematography
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Frankenstein – Dan Laustsen','Frankenstein'),
    ('Marty Supreme – Darius Khondji','Marty Supreme'),
    ('One Battle After Another – Michael Bauman','One Battle After Another'),
    ('Sinners – Autumn Durald Arkapaw','Sinners'),
    ('Train Dreams – Adolpho Veloso','Train Dreams')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Cinematography'
ON CONFLICT DO NOTHING;

-- Best Costume Design
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Avatar: Fire and Ash – Deborah L. Scott','Avatar: Fire and Ash'),
    ('Frankenstein – Kate Hawley','Frankenstein'),
    ('Hamnet – Malgosia Turzanska','Hamnet'),
    ('Marty Supreme – Miyako Bellizzi','Marty Supreme'),
    ('Sinners – Ruth E. Carter','Sinners')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Costume Design'
ON CONFLICT DO NOTHING;

-- Best Film Editing
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('F1 – Stephen Mirrione','F1'),
    ('Marty Supreme – Ronald Bronstein & Josh Safdie','Marty Supreme'),
    ('One Battle After Another – Andy Jurgensen','One Battle After Another'),
    ('Sentimental Value – Olivier Bugge Coutté','Sentimental Value'),
    ('Sinners – Michael P. Shawver','Sinners')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Film Editing'
ON CONFLICT DO NOTHING;

-- Best International Feature Film
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, NULL
FROM "movies" m
JOIN "categories" c ON c.name = 'Best International Feature Film'
WHERE m.title IN (
  'The Secret Agent','It Was Just an Accident','Sentimental Value','Sirāt','The Voice of Hind Rajab'
)
ON CONFLICT DO NOTHING;

-- Best Makeup and Hairstyling
INSERT INTO "nominees" ("movie_id", "category_id", "nominee_name")
SELECT m.id, c.id, v.nominee
FROM "categories" c
JOIN (
  VALUES
    ('Frankenstein – Mike Hill, Jordan Samuel & Cliona Furey','Frankenstein'),
    ('Kokuho – Kyoko Toyokawa, Naomi Hibino & Tadashi Nishimatsu','Kokuho'),
    ('Sinners – Ken Diaz, Mike Fontaine & Shunika Terry','Sinners'),
    ('The Smashing Machine – Kazu Hiro, Glen Griffin & Bjoern Rehbein','The Smashing Machine'),
    ('The Ugly Stepsister – Thomas Foldberg & Anne Cathrine Sauerberg','The Ugly Stepsister')
) AS v(nominee, title) ON TRUE
JOIN "movies" m ON m.title = v.title
WHERE c.name = 'Best Makeup and Hairstyling'
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    nickname TEXT NOT NULL,
    bio TEXT,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS votes (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nominated_id INT NOT NULL REFERENCES nominees(id) ON DELETE CASCADE,
    category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, category_id)
);
