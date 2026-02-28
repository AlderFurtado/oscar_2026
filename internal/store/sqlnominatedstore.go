package store

import (
	"database/sql"
	"fmt"

	"votacao/models"
)

// SQLNominatedStore implements NominatedStore using Postgres.
type SQLNominatedStore struct{ db *sql.DB }

func NewSQLNominated(db *sql.DB) *SQLNominatedStore { return &SQLNominatedStore{db: db} }

func (s *SQLNominatedStore) Insert(n *models.Nominated) (int64, error) {
	var id int64
	err := s.db.QueryRow("INSERT INTO nominated (movie_id, category_id, name) VALUES ($1,$2,$3) RETURNING id", n.MovieID, n.CategoryID, n.Name).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("insert nominated: %w", err)
	}
	return id, nil
}

func (s *SQLNominatedStore) InsertMany(ns []models.Nominated) ([]int64, error) {
	if len(ns) == 0 {
		return []int64{}, nil
	}
	tx, err := s.db.Begin()
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	stmt, err := tx.Prepare("INSERT INTO nominated (movie_id, category_id, name) VALUES ($1,$2,$3) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare: %w", err)
	}
	defer stmt.Close()
	ids := make([]int64, 0, len(ns))
	for _, n := range ns {
		var id int64
		if err := stmt.QueryRow(n.MovieID, n.CategoryID, n.Name).Scan(&id); err != nil {
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

func (s *SQLNominatedStore) Get(id int64) (*models.Nominated, error) {
	var n models.Nominated
	row := s.db.QueryRow("SELECT id, movie_id, category_id, name FROM nominated WHERE id=$1", id)
	if err := row.Scan(&n.ID, &n.MovieID, &n.CategoryID, &n.Name); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get nominated: %w", err)
	}
	return &n, nil
}

func (s *SQLNominatedStore) List() ([]models.Nominated, error) {
	rows, err := s.db.Query("SELECT id, movie_id, category_id, name FROM nominated ORDER BY id DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list nominated: %w", err)
	}
	defer rows.Close()
	var out []models.Nominated
	for rows.Next() {
		var n models.Nominated
		if err := rows.Scan(&n.ID, &n.MovieID, &n.CategoryID, &n.Name); err != nil {
			return nil, fmt.Errorf("scan nominated: %w", err)
		}
		out = append(out, n)
	}
	return out, nil
}
