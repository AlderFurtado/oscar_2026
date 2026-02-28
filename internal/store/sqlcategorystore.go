package store

import (
	"database/sql"
	"fmt"

	"votacao/models"
)

// SQLCategoryStore implements CategoryStore using a Postgres DB.
type SQLCategoryStore struct {
	db *sql.DB
}

func NewSQLCategory(db *sql.DB) *SQLCategoryStore { return &SQLCategoryStore{db: db} }

func (s *SQLCategoryStore) Insert(c *models.Category) (int64, error) {
	var id int64
	err := s.db.QueryRow("INSERT INTO categories (name) VALUES ($1) RETURNING id", c.Name).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("insert category: %w", err)
	}
	return id, nil
}

func (s *SQLCategoryStore) InsertMany(cs []models.Category) ([]int64, error) {
	if len(cs) == 0 {
		return []int64{}, nil
	}
	tx, err := s.db.Begin()
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	stmt, err := tx.Prepare("INSERT INTO categories (name) VALUES ($1) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare: %w", err)
	}
	defer stmt.Close()

	ids := make([]int64, 0, len(cs))
	for _, c := range cs {
		var id int64
		if err := stmt.QueryRow(c.Name).Scan(&id); err != nil {
			tx.Rollback()
			return nil, fmt.Errorf("insert categories: %w", err)
		}
		ids = append(ids, id)
	}
	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}
	return ids, nil
}

func (s *SQLCategoryStore) Get(id int64) (*models.Category, error) {
	var c models.Category
	row := s.db.QueryRow("SELECT id, name FROM categories WHERE id=$1", id)
	if err := row.Scan(&c.ID, &c.Name); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get category: %w", err)
	}
	return &c, nil
}

func (s *SQLCategoryStore) List() ([]models.Category, error) {
	rows, err := s.db.Query("SELECT id, name FROM categories ORDER BY id DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list categories: %w", err)
	}
	defer rows.Close()
	var out []models.Category
	for rows.Next() {
		var c models.Category
		if err := rows.Scan(&c.ID, &c.Name); err != nil {
			return nil, fmt.Errorf("scan category: %w", err)
		}
		out = append(out, c)
	}
	return out, nil
}
