-- Fix Original Song nominees with correct 2026 data

-- First, add missing movies if not exist
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Diane Warren: Relentless'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Diane Warren: Relentless');

-- KPop Demon Hunters should already exist from Animated Feature Film
-- Sinners should already exist
-- Viva Verdi! should already exist
-- Train Dreams should already exist

-- Delete existing Original Song nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Original Song');

-- Insert correct Original Song nominees
-- 1. Dear Me - from Diane Warren: Relentless
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Dear Me - Music and Lyric by Diane Warren'
FROM movies m, categories c 
WHERE m.title = 'Diane Warren: Relentless' AND c.name = 'Original Song';

-- 2. Golden - from KPop Demon Hunters
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Golden - Music and Lyric by EJAE, Mark Sonnenblick, Joong Gyu Kwak, Yu Han Lee, Hee Dong Nam, Jeong Hoon Seo and Teddy Park'
FROM movies m, categories c 
WHERE m.title = 'KPop Demon Hunters' AND c.name = 'Original Song';

-- 3. I Lied To You - from Sinners
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'I Lied To You - Music and Lyric by Raphael Saadiq and Ludwig Goransson'
FROM movies m, categories c 
WHERE m.title = 'Sinners' AND c.name = 'Original Song';

-- 4. Sweet Dreams Of Joy - from Viva Verdi!
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Sweet Dreams Of Joy - Music and Lyric by Nicholas Pike'
FROM movies m, categories c 
WHERE m.title = 'Viva Verdi!' AND c.name = 'Original Song';

-- 5. Train Dreams - from Train Dreams
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Train Dreams - Music by Nick Cave and Bryce Dessner; Lyric by Nick Cave'
FROM movies m, categories c 
WHERE m.title = 'Train Dreams' AND c.name = 'Original Song';
