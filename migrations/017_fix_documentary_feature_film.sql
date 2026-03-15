-- Fix Documentary Feature Film nominees with correct 2026 data

-- First, add missing movies if not exist
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Alabama Solution'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Alabama Solution');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Come See Me in the Good Light'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Come See Me in the Good Light');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Cutting through Rocks'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Cutting through Rocks');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Mr. Nobody against Putin'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Mr. Nobody against Putin');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Perfect Neighbor'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Perfect Neighbor');

-- Delete existing Documentary Feature Film nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Documentary Feature Film');

-- Insert correct Documentary Feature Film nominees
-- 1. The Alabama Solution - Andrew Jarecki and Charlotte Kaufman
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Andrew Jarecki and Charlotte Kaufman'
FROM movies m, categories c 
WHERE m.title = 'The Alabama Solution' AND c.name = 'Documentary Feature Film';

-- 2. Come See Me in the Good Light - Ryan White, Jessica Hargrave, Tig Notaro and Stef Willen
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Ryan White, Jessica Hargrave, Tig Notaro and Stef Willen'
FROM movies m, categories c 
WHERE m.title = 'Come See Me in the Good Light' AND c.name = 'Documentary Feature Film';

-- 3. Cutting through Rocks - Sara Khaki and Mohammadreza Eyni
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Sara Khaki and Mohammadreza Eyni'
FROM movies m, categories c 
WHERE m.title = 'Cutting through Rocks' AND c.name = 'Documentary Feature Film';

-- 4. Mr. Nobody against Putin - David Borenstein, Pavel Talankin, Helle Faber and Alžběta Karásková
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'David Borenstein, Pavel Talankin, Helle Faber and Alžběta Karásková'
FROM movies m, categories c 
WHERE m.title = 'Mr. Nobody against Putin' AND c.name = 'Documentary Feature Film';

-- 5. The Perfect Neighbor - Geeta Gandbhir, Alisa Payne, Nikon Kwantu and Sam Bisbee
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Geeta Gandbhir, Alisa Payne, Nikon Kwantu and Sam Bisbee'
FROM movies m, categories c 
WHERE m.title = 'The Perfect Neighbor' AND c.name = 'Documentary Feature Film';
