-- Fix Documentary Short Film nominees with correct 2026 data

-- First, add missing movies if not exist
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'All the Empty Rooms'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'All the Empty Rooms');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Armed Only with a Camera: The Life and Death of Brent Renaud'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Armed Only with a Camera: The Life and Death of Brent Renaud');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Children No More: "Were and Are Gone"'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Children No More: "Were and Are Gone"');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'The Devil Is Busy'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Devil Is Busy');

INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Perfectly a Strangeness'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Perfectly a Strangeness');

-- Delete existing Documentary Short Film nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Documentary Short Film');

-- Insert correct Documentary Short Film nominees
-- 1. All the Empty Rooms - Joshua Seftel and Conall Jones
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Joshua Seftel and Conall Jones'
FROM movies m, categories c 
WHERE m.title = 'All the Empty Rooms' AND c.name = 'Documentary Short Film';

-- 2. Armed Only with a Camera: The Life and Death of Brent Renaud - Craig Renaud and Juan Arredondo
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Craig Renaud and Juan Arredondo'
FROM movies m, categories c 
WHERE m.title = 'Armed Only with a Camera: The Life and Death of Brent Renaud' AND c.name = 'Documentary Short Film';

-- 3. Children No More: "Were and Are Gone" - Hilla Medalia and Sheila Nevins
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Hilla Medalia and Sheila Nevins'
FROM movies m, categories c 
WHERE m.title = 'Children No More: "Were and Are Gone"' AND c.name = 'Documentary Short Film';

-- 4. The Devil Is Busy - Christalyn Hampton and Geeta Gandbhir
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Christalyn Hampton and Geeta Gandbhir'
FROM movies m, categories c 
WHERE m.title = 'The Devil Is Busy' AND c.name = 'Documentary Short Film';

-- 5. Perfectly a Strangeness - Alison McAlpin
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Alison McAlpin'
FROM movies m, categories c 
WHERE m.title = 'Perfectly a Strangeness' AND c.name = 'Documentary Short Film';
