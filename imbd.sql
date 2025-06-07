USE imbd;
-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS 
    movie_artist_roles,
    artist_skills,
    reviews,
    movie_genres,
    media,
    movies,
    directors,
    artists,
    roles,
    skills,
    genres,
    users;

SET FOREIGN_KEY_CHECKS = 1;



-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Genres table
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

-- Skills table
CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(50) NOT NULL
);

-- Roles table
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- Artists table
CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INT
);

-- Directors table
CREATE TABLE directors (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year INT
);

-- Movies table
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_year INT,
    rating FLOAT,
    director_id INT,
    FOREIGN KEY (director_id) REFERENCES directors(director_id)
);

-- Media table (each movie can have multiple media)
CREATE TABLE media (
    media_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    media_type VARCHAR(50),
    media_url VARCHAR(255),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Movie genres (many-to-many relationship)
CREATE TABLE movie_genres (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Reviews (each movie can have multiple reviews by users)
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    user_id INT,
    review_text TEXT,
    rating FLOAT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Artist skills (many-to-many relationship)
CREATE TABLE artist_skills (
    artist_id INT,
    skill_id INT,
    PRIMARY KEY (artist_id, skill_id),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- Movie-artist-role mapping (many-to-many with role)
CREATE TABLE movie_artist_roles (
    movie_id INT,
    artist_id INT,
    role_id INT,
    PRIMARY KEY (movie_id, artist_id, role_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert users
INSERT INTO users (username, email) VALUES
('tamilfan1', 'tamilfan1@example.com'),
('kollywoodlover', 'kollywoodlover@example.com');

-- Insert genres
INSERT INTO genres (genre_name) VALUES
('Action'),   
('romance'),   
('Drama'),   
('Horror');      

-- Insert skills
INSERT INTO skills (skill_name) VALUES
('Acting'),   
('Singing'),   
('Dancing'),     
('Producing');

-- Insert roles
INSERT INTO roles (role_name) VALUES
('Lead Actor'),       
('Supporting Actorr'),          
('Director'),               
('Producer');           

-- Insert artists
INSERT INTO artists (name, birth_year) VALUES
('Rajinikanth', 1950),
('Kamal Haasan', 1954),
('Ajith', 1971),
('Vijay', 1974);

-- Insert directors
INSERT INTO directors (name, birth_year) VALUES
('Manirathnam', 1956),
('Suseendran', 1941);

-- Insert movies
INSERT INTO movies (title, release_year, rating, director_id) VALUES
('Ponniyin Selvan', 2022, 8.5, 1),  -- Directed by Manirathnam
('Theri', 2015, 7.8, 2);             -- Directed by Suseendran

-- Insert media for movies
INSERT INTO media (movie_id, media_type, media_url) VALUES
(1, 'Prasaram', 'http://example.com/ponniyin_selvan_trailer.mp4'),
(1, 'Poster', 'http://example.com/ponniyin_selvan_poster.jpg'),
(2, 'Prasaram', 'http://example.com/theri_trailer.mp4');

-- Link movies to genres
INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1, 3), -- Ponniyin Selvan - Drama
(2, 1); -- Theri - Action

-- Insert reviews
INSERT INTO reviews (movie_id, user_id, review_text, rating) VALUES
(1, 1, 'greatest historiscal movie!', 9.0),
(1, 2, 'topmost film in his career.', 8.7),
(2, 1, 'interesting movie.', 8.0);

-- Link artist skills
INSERT INTO artist_skills (artist_id, skill_id) VALUES
(1, 1), -- Rajinikanth - acting
(2, 1), -- Kamal Haasan - acting
(3, 1), -- Ajith - acting
(4, 1), -- Vijay - acting
(1, 2); -- Rajinikanth - singing

-- Assign roles artists played in movies
INSERT INTO movie_artist_roles (movie_id, artist_id, role_id) VALUES
(1, 1, 1), -- Ponniyin Selvan - Rajinikanth - Lead actor
(1, 2, 3), -- Ponniyin Selvan - Kamal Haasan - Director
(2, 4, 1), -- Theri - Vijay - Lead actor
(2, 3, 4); -- Theri - Ajith - Producer


SELECT m.title, g.genre_name
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE m.title = 'Ponniyin Selvan';

SELECT m.title, u.username, r.review_text, r.rating
FROM reviews r
JOIN movies m ON r.movie_id = m.movie_id
JOIN users u ON r.user_id = u.user_id
WHERE m.title = 'Ponniyin Selvan';

SELECT m.title, a.name AS artist_name, ro.role_name
FROM movie_artist_roles mar
JOIN movies m ON mar.movie_id = m.movie_id
JOIN artists a ON mar.artist_id = a.artist_id
JOIN roles ro ON mar.role_id = ro.role_id
WHERE m.title = 'Ponniyin Selvan';

SELECT a.name, s.skill_name
FROM artist_skills ask
JOIN artists a ON ask.artist_id = a.artist_id
JOIN skills s ON ask.skill_id = s.skill_id
WHERE a.name = 'Rajinikanth';
