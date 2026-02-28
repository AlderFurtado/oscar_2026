package db

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

// Open opens a Postgres connection and ensures the movies table exists.
func Open(dsn string) (*sql.DB, error) {
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, fmt.Errorf("sql.Open: %w", err)
	}
	if err := db.Ping(); err != nil {
		db.Close()
		return nil, fmt.Errorf("db.Ping: %w", err)
	}
	if err := ensureSchema(db); err != nil {
		db.Close()
		return nil, err
	}
	return db, nil
}

func ensureSchema(db *sql.DB) error {
	q := `
CREATE TABLE IF NOT EXISTS movies (
	id SERIAL PRIMARY KEY,
	title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS nominated (
	id SERIAL PRIMARY KEY,
	movie_id INT NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
	category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
	name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
	id UUID PRIMARY KEY,
	nickname TEXT NOT NULL,
	bio TEXT,
	email TEXT NOT NULL UNIQUE,
	password_hash TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS votes (
	id SERIAL PRIMARY KEY,
	user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	nominated_id INT NOT NULL REFERENCES nominated(id) ON DELETE CASCADE,
	category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
	UNIQUE (user_id, category_id)
);
`
	_, err := db.Exec(q)
	return err
}
