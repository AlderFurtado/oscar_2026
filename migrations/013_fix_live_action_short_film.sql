-- Fix Live Action Short Film nominees with correct 2026 data

-- First, add missing movies if not exist
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Butcher''s Stain'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Butcher''s Stain');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'A Friend of Dorothy'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'A Friend of Dorothy');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Jane Austen''s Period Drama'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Jane Austen''s Period Drama');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Singers'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Singers');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Two People Exchanging Saliva'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Two People Exchanging Saliva');

-- Delete existing Live Action Short Film nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Live Action Short Film');

-- Insert correct Live Action Short Film nominees
-- 1. Butcher's Stain - Meyer Levinson-Blount and Oron Caspi
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Meyer Levinson-Blount and Oron Caspi'
FROM movies m, categories c 
WHERE m.title = 'Butcher''s Stain' AND c.name = 'Live Action Short Film';

-- 2. A Friend of Dorothy - Lee Knight and James Dean
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Lee Knight and James Dean'
FROM movies m, categories c 
WHERE m.title = 'A Friend of Dorothy' AND c.name = 'Live Action Short Film';

-- 3. Jane Austen's Period Drama - Julia Aks and Steve Pinder
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Julia Aks and Steve Pinder'
FROM movies m, categories c 
WHERE m.title = 'Jane Austen''s Period Drama' AND c.name = 'Live Action Short Film';

-- 4. The Singers - Sam A. Davis and Jack Piatt
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Sam A. Davis and Jack Piatt'
FROM movies m, categories c 
WHERE m.title = 'The Singers' AND c.name = 'Live Action Short Film';

-- 5. Two People Exchanging Saliva - Alexandre Singh and Natalie Musteata
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Alexandre Singh and Natalie Musteata'
FROM movies m, categories c 
WHERE m.title = 'Two People Exchanging Saliva' AND c.name = 'Live Action Short Film';
