package store

import (
	"database/sql"
	"fmt"

	"votacao/models"
)

// SQLNominatedStore implements NominatedStore using Postgres.
type SQLNominatedStore struct{ db *sql.DB }

func NewSQLNominated(db *sql.DB) *SQLNominatedStore { return &SQLNominatedStore{db: db} }

func (s *SQLNominatedStore) Insert(n *models.Nominated) (string, error) {
	var id string
	var name interface{} = n.Name
	if n.Name == "" {
		name = nil
	}
	err := s.db.QueryRow("INSERT INTO nominees (movie_id, category_id, nominee_name) VALUES ($1,$2,$3) RETURNING id", n.MovieID, n.CategoryID, name).Scan(&id)
	if err != nil {
		return "", fmt.Errorf("insert nominated: %w", err)
	}
	return id, nil
}

func (s *SQLNominatedStore) InsertMany(ns []models.Nominated) ([]string, error) {
	if len(ns) == 0 {
		return []string{}, nil
	}
	tx, err := s.db.Begin()
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	stmt, err := tx.Prepare("INSERT INTO nominees (movie_id, category_id, nominee_name) VALUES ($1,$2,$3) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare: %w", err)
	}
	defer stmt.Close()
	ids := make([]string, 0, len(ns))
	for _, n := range ns {
		var id string
		var name interface{} = n.Name
		if n.Name == "" {
			name = nil
		}
		if err := stmt.QueryRow(n.MovieID, n.CategoryID, name).Scan(&id); err != nil {
			tx.Rollback()
			return nil, fmt.Errorf("insert many nominated: %w", err)
		}
		ids = append(ids, id)
	}
	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}
	return ids, nil
}

func (s *SQLNominatedStore) Get(id string) (*models.Nominated, error) {
	var n models.Nominated
	row := s.db.QueryRow("SELECT id, movie_id, category_id, nominee_name FROM nominees WHERE id=$1", id)
	var name sql.NullString
	if err := row.Scan(&n.ID, &n.MovieID, &n.CategoryID, &name); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get nominated: %w", err)
	}
	if name.Valid {
		n.Name = name.String
	} else {
		n.Name = ""
	}
	return &n, nil
}

func (s *SQLNominatedStore) List() ([]models.Nominated, error) {
	rows, err := s.db.Query("SELECT id, movie_id, category_id, nominee_name FROM nominees ORDER BY created_at DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list nominated: %w", err)
	}
	defer rows.Close()
	var out []models.Nominated
	for rows.Next() {
		var n models.Nominated
		var name sql.NullString
		if err := rows.Scan(&n.ID, &n.MovieID, &n.CategoryID, &name); err != nil {
			return nil, fmt.Errorf("scan nominated: %w", err)
		}
		if name.Valid {
			n.Name = name.String
		} else {
			n.Name = ""
		}
		out = append(out, n)
	}
	return out, nil
}
