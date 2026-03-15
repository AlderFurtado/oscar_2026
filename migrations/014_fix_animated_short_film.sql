-- Fix Animated Short Film nominees with correct 2026 data

-- First, add missing movies if not exist
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Butterfly'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Butterfly');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Forevergreen'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Forevergreen');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Girl Who Cried Pearls'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Girl Who Cried Pearls');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Retirement Plan'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Retirement Plan');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Three Sisters'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Three Sisters');

-- Delete existing Animated Short Film nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Animated Short Film');

-- Insert correct Animated Short Film nominees
-- 1. Butterfly - Florence Miailhe and Ron Dyens
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Florence Miailhe and Ron Dyens'
FROM movies m, categories c 
WHERE m.title = 'Butterfly' AND c.name = 'Animated Short Film';

-- 2. Forevergreen - Nathan Engelhardt and Jeremy Spears
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Nathan Engelhardt and Jeremy Spears'
FROM movies m, categories c 
WHERE m.title = 'Forevergreen' AND c.name = 'Animated Short Film';

-- 3. The Girl Who Cried Pearls - Chris Lavis and Maciek Szczerbowski
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Chris Lavis and Maciek Szczerbowski'
FROM movies m, categories c 
WHERE m.title = 'The Girl Who Cried Pearls' AND c.name = 'Animated Short Film';

-- 4. Retirement Plan - John Kelly and Andrew Freedman
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'John Kelly and Andrew Freedman'
FROM movies m, categories c 
WHERE m.title = 'Retirement Plan' AND c.name = 'Animated Short Film';

-- 5. The Three Sisters - Konstantin Bronzit
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Konstantin Bronzit'
FROM movies m, categories c 
WHERE m.title = 'The Three Sisters' AND c.name = 'Animated Short Film';
