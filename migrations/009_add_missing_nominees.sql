-- Oscar 2026 Additional Nominees
-- Adding missing nominees for categories not fully populated in migration 008

-- Directing
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Josh Safdie - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Directing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Paul Thomas Anderson - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Directing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Guillermo del Toro - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Directing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sam Mendes - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Directing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Ryan Coogler - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Directing';

-- Cinematography
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Darius Khondji - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Cinematography';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Dan Laustsen - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Cinematography';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Roger Deakins - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Cinematography';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Autumn Durald Arkapaw - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Cinematography';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Paul Thomas Anderson - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Cinematography';

-- Film Editing
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Benny Safdie - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Film Editing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Andy Jurgensen & Paul Thomas Anderson - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Film Editing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sandra Adair - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Film Editing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Lee Smith - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Film Editing';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Michael P. Shawver - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Film Editing';

-- Costume Design
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Luis Sequeira - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Costume Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Alexandra Byrne - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Costume Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Mark Bridges - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Costume Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Mark Bridges - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Costume Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Ruth E. Carter - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Costume Design';

-- Makeup and Hairstyling
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Makeup and Hairstyling';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Makeup and Hairstyling';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Makeup and Hairstyling';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Makeup and Hairstyling';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Makeup and Hairstyling';

-- Original Score
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Ludwig Göransson - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Original Score';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Jonny Greenwood - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Original Score';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Jonny Greenwood - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Original Score';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Thomas Newman - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Original Score';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Alexandre Desplat - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Original Score';

-- Additional Original Songs
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Beautiful That Way - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Original Song';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Last Rodeo - F1'
FROM movies m, categories c WHERE m.title = 'F1' AND c.name = 'Original Song';

-- Animated Feature Film (placeholder movies needed)
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Flow'),
  (gen_random_uuid(), 'Inside Out 2'),
  (gen_random_uuid(), 'Memoir of a Snail'),
  (gen_random_uuid(), 'Wallace & Gromit: Vengeance Most Fowl'),
  (gen_random_uuid(), 'The Wild Robot');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Flow'
FROM movies m, categories c WHERE m.title = 'Flow' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Inside Out 2'
FROM movies m, categories c WHERE m.title = 'Inside Out 2' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Memoir of a Snail'
FROM movies m, categories c WHERE m.title = 'Memoir of a Snail' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Wallace & Gromit: Vengeance Most Fowl'
FROM movies m, categories c WHERE m.title = 'Wallace & Gromit: Vengeance Most Fowl' AND c.name = 'Animated Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Wild Robot'
FROM movies m, categories c WHERE m.title = 'The Wild Robot' AND c.name = 'Animated Feature Film';

-- International Feature Film (placeholder movies needed)
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Emilia Pérez'),
  (gen_random_uuid(), 'The Girl with the Needle'),
  (gen_random_uuid(), 'I''m Still Here'),
  (gen_random_uuid(), 'The Seed of the Sacred Fig'),
  (gen_random_uuid(), 'Universal Language');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Emilia Pérez (France)'
FROM movies m, categories c WHERE m.title = 'Emilia Pérez' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Girl with the Needle (Denmark)'
FROM movies m, categories c WHERE m.title = 'The Girl with the Needle' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'I''m Still Here (Brazil)'
FROM movies m, categories c WHERE m.title = 'I''m Still Here' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Seed of the Sacred Fig (Germany)'
FROM movies m, categories c WHERE m.title = 'The Seed of the Sacred Fig' AND c.name = 'International Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Universal Language (Canada)'
FROM movies m, categories c WHERE m.title = 'Universal Language' AND c.name = 'International Feature Film';

-- Documentary Feature Film
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Black Box Diaries'),
  (gen_random_uuid(), 'No Other Land'),
  (gen_random_uuid(), 'Porcelain War'),
  (gen_random_uuid(), 'Soundtrack to a Coup d''Etat'),
  (gen_random_uuid(), 'Sugarcane');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Black Box Diaries'
FROM movies m, categories c WHERE m.title = 'Black Box Diaries' AND c.name = 'Documentary Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'No Other Land'
FROM movies m, categories c WHERE m.title = 'No Other Land' AND c.name = 'Documentary Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Porcelain War'
FROM movies m, categories c WHERE m.title = 'Porcelain War' AND c.name = 'Documentary Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Soundtrack to a Coup d''Etat'
FROM movies m, categories c WHERE m.title = 'Soundtrack to a Coup d''Etat' AND c.name = 'Documentary Feature Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sugarcane'
FROM movies m, categories c WHERE m.title = 'Sugarcane' AND c.name = 'Documentary Feature Film';

-- Documentary Short Film
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Death by Numbers'),
  (gen_random_uuid(), 'I Am Ready, Warden'),
  (gen_random_uuid(), 'Incident'),
  (gen_random_uuid(), 'Instruments of a Beating Heart'),
  (gen_random_uuid(), 'The Only Girl in the Orchestra');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Death by Numbers'
FROM movies m, categories c WHERE m.title = 'Death by Numbers' AND c.name = 'Documentary Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'I Am Ready, Warden'
FROM movies m, categories c WHERE m.title = 'I Am Ready, Warden' AND c.name = 'Documentary Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Incident'
FROM movies m, categories c WHERE m.title = 'Incident' AND c.name = 'Documentary Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Instruments of a Beating Heart'
FROM movies m, categories c WHERE m.title = 'Instruments of a Beating Heart' AND c.name = 'Documentary Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Only Girl in the Orchestra'
FROM movies m, categories c WHERE m.title = 'The Only Girl in the Orchestra' AND c.name = 'Documentary Short Film';

-- Live Action Short Film
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'A Lien'),
  (gen_random_uuid(), 'Anuja'),
  (gen_random_uuid(), 'I''m Not a Robot'),
  (gen_random_uuid(), 'The Last Ranger'),
  (gen_random_uuid(), 'The Man Who Could Not Remain Silent');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'A Lien'
FROM movies m, categories c WHERE m.title = 'A Lien' AND c.name = 'Live Action Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Anuja'
FROM movies m, categories c WHERE m.title = 'Anuja' AND c.name = 'Live Action Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'I''m Not a Robot'
FROM movies m, categories c WHERE m.title = 'I''m Not a Robot' AND c.name = 'Live Action Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Last Ranger'
FROM movies m, categories c WHERE m.title = 'The Last Ranger' AND c.name = 'Live Action Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Man Who Could Not Remain Silent'
FROM movies m, categories c WHERE m.title = 'The Man Who Could Not Remain Silent' AND c.name = 'Live Action Short Film';

-- Animated Short Film
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Beautiful Men'),
  (gen_random_uuid(), 'In the Shadow of the Cypress'),
  (gen_random_uuid(), 'Magic Candies'),
  (gen_random_uuid(), 'Wander to Wonder'),
  (gen_random_uuid(), 'Yuck!');

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Beautiful Men'
FROM movies m, categories c WHERE m.title = 'Beautiful Men' AND c.name = 'Animated Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'In the Shadow of the Cypress'
FROM movies m, categories c WHERE m.title = 'In the Shadow of the Cypress' AND c.name = 'Animated Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Magic Candies'
FROM movies m, categories c WHERE m.title = 'Magic Candies' AND c.name = 'Animated Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Wander to Wonder'
FROM movies m, categories c WHERE m.title = 'Wander to Wonder' AND c.name = 'Animated Short Film';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Yuck!'
FROM movies m, categories c WHERE m.title = 'Yuck!' AND c.name = 'Animated Short Film';

-- Best Casting
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Francine Maisler - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Cassandra Kulukundis - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Nina Gold - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Robin Gurland - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Best Casting';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Cassandra Kulukundis - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Best Casting';
