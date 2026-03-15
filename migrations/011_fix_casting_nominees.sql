-- Fix Best Casting nominees for Oscar 2026

DELETE FROM nominees WHERE category_id IN (
  SELECT id FROM categories WHERE name = 'Best Casting'
);

-- Best Casting nominees (correct list)
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Hamnet - Nina Gold'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Marty Supreme - Jennifer Venditti'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another - Cassandra Kulukundis'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Secret Agent - Gabriel Domingues'
FROM movies m, categories c WHERE m.title = 'The Secret Agent' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners - Francine Maisler'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Best Casting';
