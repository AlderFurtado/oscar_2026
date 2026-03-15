package store

import (
	"database/sql"
	"fmt"

	"votacao/models"
)

// SQLWinnerStore implements WinnerStore using a SQL database.
type SQLWinnerStore struct {
	db *sql.DB
}

// NewSQLWinnerStore creates a new SQLWinnerStore.
func NewSQLWinnerStore(db *sql.DB) *SQLWinnerStore {
	return &SQLWinnerStore{db: db}
}

func (s *SQLWinnerStore) Insert(w *models.Winner) (string, error) {
	var id string
	err := s.db.QueryRow(
		"INSERT INTO winners (nominated_id) VALUES ($1) RETURNING id",
		w.NominatedID,
	).Scan(&id)
	if err != nil {
		return "", fmt.Errorf("insert winner: %w", err)
	}
	return id, nil
}

func (s *SQLWinnerStore) Get(id string) (*models.Winner, error) {
	var w models.Winner
	row := s.db.QueryRow("SELECT id, nominated_id FROM winners WHERE id=$1", id)
	if err := row.Scan(&w.ID, &w.NominatedID); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get winner: %w", err)
	}
	return &w, nil
}

func (s *SQLWinnerStore) GetByNominated(nominatedID string) (*models.Winner, error) {
	var w models.Winner
	row := s.db.QueryRow("SELECT id, nominated_id FROM winners WHERE nominated_id=$1", nominatedID)
	if err := row.Scan(&w.ID, &w.NominatedID); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get winner by nominated: %w", err)
	}
	return &w, nil
}

func (s *SQLWinnerStore) List() ([]models.Winner, error) {
	rows, err := s.db.Query("SELECT id, nominated_id FROM winners")
	if err != nil {
		return nil, fmt.Errorf("list winners: %w", err)
	}
	defer rows.Close()

	var winners []models.Winner
	for rows.Next() {
		var w models.Winner
		if err := rows.Scan(&w.ID, &w.NominatedID); err != nil {
			return nil, fmt.Errorf("scan winner: %w", err)
		}
		winners = append(winners, w)
	}
	return winners, rows.Err()
}

func (s *SQLWinnerStore) Delete(id string) error {
	_, err := s.db.Exec("DELETE FROM winners WHERE id=$1", id)
	if err != nil {
		return fmt.Errorf("delete winner: %w", err)
	}
	return nil
}
