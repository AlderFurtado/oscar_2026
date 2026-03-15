-- Fix Actress in a Supporting Role nominees with correct 2026 data

-- First, add missing movie "Weapons" if not exists
INSERT INTO movies (id, title)
SELECT gen_random_uuid(), 'Weapons'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Weapons');

-- Delete existing Actress in a Supporting Role nominees
DELETE FROM nominees 
WHERE category_id = (SELECT id FROM categories WHERE name = 'Actress in a Supporting Role');

-- Insert correct Actress in a Supporting Role nominees
-- 1. Elle Fanning - Sentimental Value
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Elle Fanning'
FROM movies m, categories c 
WHERE m.title = 'Sentimental Value' AND c.name = 'Actress in a Supporting Role';

-- 2. Inga Ibsdotter Lilleaas - Sentimental Value
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Inga Ibsdotter Lilleaas'
FROM movies m, categories c 
WHERE m.title = 'Sentimental Value' AND c.name = 'Actress in a Supporting Role';

-- 3. Amy Madigan - Weapons
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Amy Madigan'
FROM movies m, categories c 
WHERE m.title = 'Weapons' AND c.name = 'Actress in a Supporting Role';

-- 4. Wunmi Mosaku - Sinners
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Wunmi Mosaku'
FROM movies m, categories c 
WHERE m.title = 'Sinners' AND c.name = 'Actress in a Supporting Role';

-- 5. Teyana Taylor - One Battle after Another
INSERT INTO nominees (id, movie_id, category_id, nominee_name)
SELECT gen_random_uuid(), m.id, c.id, 'Teyana Taylor'
FROM movies m, categories c 
WHERE m.title = 'One Battle after Another' AND c.name = 'Actress in a Supporting Role';
