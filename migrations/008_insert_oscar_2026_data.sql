-- Oscar 2026 Categories and Nominees
-- First, clear existing data to avoid duplicates
DELETE FROM nominees;
DELETE FROM categories;
DELETE FROM movies;

-- Insert Movies
INSERT INTO movies (id, title) VALUES
  (gen_random_uuid(), 'Marty Supreme'),
  (gen_random_uuid(), 'One Battle after Another'),
  (gen_random_uuid(), 'Blue Moon'),
  (gen_random_uuid(), 'Sinners'),
  (gen_random_uuid(), 'The Secret Agent'),
  (gen_random_uuid(), 'Frankenstein'),
  (gen_random_uuid(), 'Sentimental Value'),
  (gen_random_uuid(), 'Hamnet'),
  (gen_random_uuid(), 'If I Had Legs I''d Kick You'),
  (gen_random_uuid(), 'Song Sung Blue'),
  (gen_random_uuid(), 'Bugonia'),
  (gen_random_uuid(), 'F1'),
  (gen_random_uuid(), 'Train Dreams'),
  (gen_random_uuid(), 'Avatar: Fire and Ash'),
  (gen_random_uuid(), 'Jurassic World Rebirth'),
  (gen_random_uuid(), 'The Lost Bus'),
  (gen_random_uuid(), 'Sirāt'),
  (gen_random_uuid(), 'Viva Verdi!');

-- Insert Categories with sequence_order
INSERT INTO categories (id, name, sequence_order) VALUES
  (gen_random_uuid(), 'Best Picture', 1),
  (gen_random_uuid(), 'Actor in a Leading Role', 2),
  (gen_random_uuid(), 'Actress in a Leading Role', 3),
  (gen_random_uuid(), 'Actor in a Supporting Role', 4),
  (gen_random_uuid(), 'Actress in a Supporting Role', 5),
  (gen_random_uuid(), 'Directing', 6),
  (gen_random_uuid(), 'Writing (Original Screenplay)', 7),
  (gen_random_uuid(), 'Writing (Adapted Screenplay)', 8),
  (gen_random_uuid(), 'Cinematography', 9),
  (gen_random_uuid(), 'Film Editing', 10),
  (gen_random_uuid(), 'Production Design', 11),
  (gen_random_uuid(), 'Costume Design', 12),
  (gen_random_uuid(), 'Makeup and Hairstyling', 13),
  (gen_random_uuid(), 'Sound', 14),
  (gen_random_uuid(), 'Visual Effects', 15),
  (gen_random_uuid(), 'Original Score', 16),
  (gen_random_uuid(), 'Original Song', 17),
  (gen_random_uuid(), 'Animated Feature Film', 18),
  (gen_random_uuid(), 'International Feature Film', 19),
  (gen_random_uuid(), 'Documentary Feature Film', 20),
  (gen_random_uuid(), 'Documentary Short Film', 21),
  (gen_random_uuid(), 'Live Action Short Film', 22),
  (gen_random_uuid(), 'Animated Short Film', 23),
  (gen_random_uuid(), 'Best Casting', 24);

-- Insert Nominees
-- Best Picture
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Bugonia'
FROM movies m, categories c WHERE m.title = 'Bugonia' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'F1'
FROM movies m, categories c WHERE m.title = 'F1' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Secret Agent'
FROM movies m, categories c WHERE m.title = 'The Secret Agent' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sentimental Value'
FROM movies m, categories c WHERE m.title = 'Sentimental Value' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Best Picture';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Train Dreams'
FROM movies m, categories c WHERE m.title = 'Train Dreams' AND c.name = 'Best Picture';

-- Actor in a Leading Role
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Timothée Chalamet - Marty Supreme'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Actor in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Leonardo DiCaprio - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Actor in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Ethan Hawke - Blue Moon'
FROM movies m, categories c WHERE m.title = 'Blue Moon' AND c.name = 'Actor in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Michael B. Jordan - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Actor in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Wagner Moura - The Secret Agent'
FROM movies m, categories c WHERE m.title = 'The Secret Agent' AND c.name = 'Actor in a Leading Role';

-- Actress in a Leading Role
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Jessie Buckley - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Actress in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Rose Byrne - If I Had Legs I''d Kick You'
FROM movies m, categories c WHERE m.title = 'If I Had Legs I''d Kick You' AND c.name = 'Actress in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Kate Hudson - Song Sung Blue'
FROM movies m, categories c WHERE m.title = 'Song Sung Blue' AND c.name = 'Actress in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Renate Reinsve - Sentimental Value'
FROM movies m, categories c WHERE m.title = 'Sentimental Value' AND c.name = 'Actress in a Leading Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Emma Stone - Bugonia'
FROM movies m, categories c WHERE m.title = 'Bugonia' AND c.name = 'Actress in a Leading Role';

-- Actor in a Supporting Role
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Benicio Del Toro - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Actor in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Jacob Elordi - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Actor in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Delroy Lindo - Sinners'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Actor in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sean Penn - One Battle after Another'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Actor in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Stellan Skarsgård - Sentimental Value'
FROM movies m, categories c WHERE m.title = 'Sentimental Value' AND c.name = 'Actor in a Supporting Role';

-- Actress in a Supporting Role
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Elle Fanning - Sentimental Value'
FROM movies m, categories c WHERE m.title = 'Sentimental Value' AND c.name = 'Actress in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Haley Lu Richardson - Frankenstein'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Actress in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Margaret Qualley - Bugonia'
FROM movies m, categories c WHERE m.title = 'Bugonia' AND c.name = 'Actress in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Alicia Vikander - Hamnet'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Actress in a Supporting Role';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Naomi Watts - If I Had Legs I''d Kick You'
FROM movies m, categories c WHERE m.title = 'If I Had Legs I''d Kick You' AND c.name = 'Actress in a Supporting Role';

-- Writing (Original Screenplay)
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Marty Supreme - Ronald Bronstein & Josh Safdie'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Writing (Original Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sentimental Value - Eskil Vogt, Joachim Trier'
FROM movies m, categories c WHERE m.title = 'Sentimental Value' AND c.name = 'Writing (Original Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners - Ryan Coogler'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Writing (Original Screenplay)';

-- Writing (Adapted Screenplay)
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Bugonia - Will Tracy'
FROM movies m, categories c WHERE m.title = 'Bugonia' AND c.name = 'Writing (Adapted Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Frankenstein - Guillermo del Toro'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Writing (Adapted Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Hamnet - Chloé Zhao & Maggie O''Farrell'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Writing (Adapted Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another - Paul Thomas Anderson'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Writing (Adapted Screenplay)';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Train Dreams - Mehdi Mahmoudian'
FROM movies m, categories c WHERE m.title = 'Train Dreams' AND c.name = 'Writing (Adapted Screenplay)';

-- Production Design
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Frankenstein - Tamara Deverell & Shane Vieau'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Production Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Hamnet - Fiona Crombie & Alice Felton'
FROM movies m, categories c WHERE m.title = 'Hamnet' AND c.name = 'Production Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Marty Supreme - Jack Fisk & Adam Willis'
FROM movies m, categories c WHERE m.title = 'Marty Supreme' AND c.name = 'Production Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another - Florencia Martin & Anthony Carlino'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Production Design';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners - Hannah Beachler & Monique Champagne'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Production Design';

-- Sound
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'F1 - Gareth John, Al Nelson, Gwendolyn Yates Whittle, Gary A. Rizzo, Juan Peralta'
FROM movies m, categories c WHERE m.title = 'F1' AND c.name = 'Sound';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Frankenstein - Greg Chapman, Nathan Robitaille, Nelson Ferreira, Christian Cooke, Brad Zoern'
FROM movies m, categories c WHERE m.title = 'Frankenstein' AND c.name = 'Sound';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'One Battle after Another - José Antonio García, Christopher Scarabosio, Tony Villaflor'
FROM movies m, categories c WHERE m.title = 'One Battle after Another' AND c.name = 'Sound';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners - Chris Welcker, Benjamin A. Burtt, Felipe Pacheco, Brandon Proctor, Steve Boeddeker'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Sound';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sirāt - Amanda Villavieja, Laia Casanovas, Yasmina Praderas'
FROM movies m, categories c WHERE m.title = 'Sirāt' AND c.name = 'Sound';

-- Visual Effects
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Avatar: Fire and Ash - Joe Letteri, Richard Baneham, Eric Saindon, Daniel Barrett'
FROM movies m, categories c WHERE m.title = 'Avatar: Fire and Ash' AND c.name = 'Visual Effects';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'F1 - Ryan Tudhope, Nicolas Chevallier, Robert Harrington, Keith Dawson'
FROM movies m, categories c WHERE m.title = 'F1' AND c.name = 'Visual Effects';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Jurassic World Rebirth - David Vickery, Stephen Aplin, Charmaine Chan, Neil Corbould'
FROM movies m, categories c WHERE m.title = 'Jurassic World Rebirth' AND c.name = 'Visual Effects';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'The Lost Bus - Charlie Noble, David Zaretti, Russell Bowen, Brandon K. McLaughlin'
FROM movies m, categories c WHERE m.title = 'The Lost Bus' AND c.name = 'Visual Effects';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sinners - Michael Ralla, Espen Nordahl, Guido Wolter, Donnie Dean'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Visual Effects';

-- Original Song
INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'I Lied to You - Sinners (Raphael Saadiq, Ludwig Goransson)'
FROM movies m, categories c WHERE m.title = 'Sinners' AND c.name = 'Original Song';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Sweet Dreams of Joy - Viva Verdi! (Nicholas Pike)'
FROM movies m, categories c WHERE m.title = 'Viva Verdi!' AND c.name = 'Original Song';

INSERT INTO nominees (id, movie_id, category_id, nominee_name) 
SELECT gen_random_uuid(), m.id, c.id, 'Train Dreams - Train Dreams (Nick Cave, Bryce Dessner)'
FROM movies m, categories c WHERE m.title = 'Train Dreams' AND c.name = 'Original Song';
