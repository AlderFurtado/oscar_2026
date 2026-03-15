-- Fix Animated Feature Film and International Feature Film nominees for Oscar 2026
-- Delete incorrect nominees from migration 009

DELETE FROM nominees WHERE category_id IN (
  SELECT id FROM categories WHERE name IN ('Animated Feature Film', 'International Feature Film')
);

-- Delete incorrect movies added in migration 009 for these categories
DELETE FROM movies WHERE title IN (
  'Flow', 'Inside Out 2', 'Memoir of a Snail', 'Wallace & Gromit: Vengeance Most Fowl', 'The Wild Robot',
  'Emilia Pérez', 'The Girl with the Needle', 'I''m Still Here', 'The Seed of the Sacred Fig', 'Universal Language',
  'Elio', 'The Day the Earth Blew Up: A Looney Tunes Movie', 'Mufasa: The Lion King', 'Moana 2', 'Lord of the Rings: The War of the Rohirrim'
);

-- Add correct movies for Animated Feature Film 2026
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Arco'),
  (gen_random_uuid(), 'Elio'),
  (gen_random_uuid(), 'KPop Demon Hunters'),
  (gen_random_uuid(), 'Little Amélie or the Character of Rain'),
  (gen_random_uuid(), 'Zootopia 2');

-- Animated Feature Film nominees
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Arco - Ugo Bienvenu, Félix de Givry, Sophie Mas, Natalie Portman'
FROM movies m, categories c WHERE m.title = 'Arco' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Elio - Madeline Sharafian, Domee Shi, Adrian Molina, Mary Alice Drumm'
FROM movies m, categories c WHERE m.title = 'Elio' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'KPop Demon Hunters - Maggie Kang, Chris Appelhans, Michelle L.M. Wong'
FROM movies m, categories c WHERE m.title = 'KPop Demon Hunters' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Little Amélie or the Character of Rain - Maïlys Vallade, Liane-Cho Han, Nidia Santiago, Henri Magalon'
FROM movies m, categories c WHERE m.title = 'Little Amélie or the Character of Rain' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Zootopia 2 - Jared Bush, Byron Howard, Yvett Merino'
FROM movies m, categories c WHERE m.title = 'Zootopia 2' AND c.name = 'Animated Feature Film';

-- Add correct movies for International Feature Film 2026
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Sentimental Value (Norway)'),
  (gen_random_uuid(), 'The Secret Agent (Brazil)'),
  (gen_random_uuid(), 'Sirāt (Spain)'),
  (gen_random_uuid(), 'Kneecap (Ireland)'),
  (gen_random_uuid(), 'September 5 (Germany)');

-- International Feature Film nominees
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sentimental Value (Norway)'
FROM movies m, categories c WHERE m.title = 'Sentimental Value (Norway)' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Secret Agent (Brazil)'
FROM movies m, categories c WHERE m.title = 'The Secret Agent (Brazil)' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sirāt (Spain)'
FROM movies m, categories c WHERE m.title = 'Sirāt (Spain)' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Kneecap (Ireland)'
FROM movies m, categories c WHERE m.title = 'Kneecap (Ireland)' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'September 5 (Germany)'
FROM movies m, categories c WHERE m.title = 'September 5 (Germany)' AND c.name = 'International Feature Film';
