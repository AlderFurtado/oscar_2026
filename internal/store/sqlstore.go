package store

import (
	"database/sql"
	"fmt"

	"votacao/models"
)

type SQLStore struct {
	db *sql.DB
}

func NewSQL(db *sql.DB) *SQLStore { return &SQLStore{db: db} }

func (s *SQLStore) Insert(m *models.Movie) (int64, error) {
	var id int64
	err := s.db.QueryRow("INSERT INTO movies (title) VALUES ($1) RETURNING id", m.Title).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("insert: %w", err)
	}
	return id, nil
}

// InsertMany inserts multiple movies in a transaction and returns their IDs in order.
func (s *SQLStore) InsertMany(ms []models.Movie) ([]int64, error) {
	if len(ms) == 0 {
		return []int64{}, nil
	}
	tx, err := s.db.Begin()
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	// prepare a statement for repeated inserts to improve performance
	stmt, err := tx.Prepare("INSERT INTO movies (title) VALUES ($1) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare: %w", err)
	}
	defer stmt.Close()

	ids := make([]int64, 0, len(ms))
	for _, m := range ms {
		var id int64
		if err := stmt.QueryRow(m.Title).Scan(&id); err != nil {
			tx.Rollback()
			return nil, fmt.Errorf("insert many: %w", err)
		}
		ids = append(ids, id)
	}
	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}
	return ids, nil
}

func (s *SQLStore) Get(id int64) (*models.Movie, error) {
	var m models.Movie
	row := s.db.QueryRow("SELECT id, title FROM movies WHERE id=$1", id)
	if err := row.Scan(&m.ID, &m.Title); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get: %w", err)
	}
	return &m, nil
}

// GetByTitle looks up a movie by title.
func (s *SQLStore) GetByTitle(title string) (*models.Movie, error) {
	var m models.Movie
	row := s.db.QueryRow("SELECT id, title FROM movies WHERE title=$1", title)
	if err := row.Scan(&m.ID, &m.Title); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get by title: %w", err)
	}
	return &m, nil
}

func (s *SQLStore) List() ([]models.Movie, error) {
	rows, err := s.db.Query("SELECT id, title FROM movies ORDER BY id DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list: %w", err)
	}
	defer rows.Close()
	var out []models.Movie
	for rows.Next() {
		var m models.Movie
		if err := rows.Scan(&m.ID, &m.Title); err != nil {
			return nil, fmt.Errorf("scan: %w", err)
		}
		out = append(out, m)
	}
	return out, nil
}
