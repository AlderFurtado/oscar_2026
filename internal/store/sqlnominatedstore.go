package store

import (
	"database/sql"
	"fmt"
	"log"

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
	// If UrlImage is empty, omit it from the INSERT so DB default applies.
	if n.UrlImage == "" {
		err := s.db.QueryRow("INSERT INTO nominees (movie_id, category_id, nominee_name) VALUES ($1,$2,$3) RETURNING id", n.MovieID, n.CategoryID, name).Scan(&id)
		if err != nil {
			return "", fmt.Errorf("insert nominated: %w", err)
		}
		return id, nil
	}
	// url provided -> include it in INSERT
	err := s.db.QueryRow("INSERT INTO nominees (movie_id, category_id, nominee_name, url_image) VALUES ($1,$2,$3,$4) RETURNING id", n.MovieID, n.CategoryID, name, n.UrlImage).Scan(&id)
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
	stmtWithUrl, err := tx.Prepare("INSERT INTO nominees (movie_id, category_id, nominee_name, url_image) VALUES ($1,$2,$3,$4) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare: %w", err)
	}
	defer stmtWithUrl.Close()
	stmtNoUrl, err := tx.Prepare("INSERT INTO nominees (movie_id, category_id, nominee_name) VALUES ($1,$2,$3) RETURNING id")
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("prepare no-url: %w", err)
	}
	defer stmtNoUrl.Close()
	ids := make([]string, 0, len(ns))
	for _, n := range ns {
		var id string
		var name interface{} = n.Name
		if n.Name == "" {
			name = nil
		}
		if n.UrlImage == "" {
			if err := stmtNoUrl.QueryRow(n.MovieID, n.CategoryID, name).Scan(&id); err != nil {
				tx.Rollback()
				return nil, fmt.Errorf("insert many nominated: %w", err)
			}
		} else {
			if err := stmtWithUrl.QueryRow(n.MovieID, n.CategoryID, name, n.UrlImage).Scan(&id); err != nil {
				tx.Rollback()
				return nil, fmt.Errorf("insert many nominated: %w", err)
			}
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
	row := s.db.QueryRow("SELECT id, movie_id, category_id, nominee_name, url_image FROM nominees WHERE id=$1", id)
	var name sql.NullString
	var url sql.NullString
	if err := row.Scan(&n.ID, &n.MovieID, &n.CategoryID, &name, &url); err != nil {
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
	if url.Valid {
		n.UrlImage = url.String
	} else {
		n.UrlImage = ""
	}
	return &n, nil
}

func (s *SQLNominatedStore) List() ([]models.Nominated, error) {
	rows, err := s.db.Query("SELECT id, movie_id, category_id, nominee_name, url_image FROM nominees ORDER BY created_at DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list nominated: %w", err)
	}
	defer rows.Close()
	var out []models.Nominated
	for rows.Next() {
		var n models.Nominated
		var name sql.NullString
		var url sql.NullString
		if err := rows.Scan(&n.ID, &n.MovieID, &n.CategoryID, &name, &url); err != nil {
			return nil, fmt.Errorf("scan nominated: %w", err)
		}
		if name.Valid {
			n.Name = name.String
		} else {
			n.Name = ""
		}
		if url.Valid {
			n.UrlImage = url.String
		} else {
			n.UrlImage = ""
		}
		out = append(out, n)
	}
	log.Printf("sqlnominatedstore: List() complete, scanned %d rows", len(out))
	return out, nil
}

// ListByCategory returns nominated rows filtered by category_id using a DB-level WHERE clause.
func (s *SQLNominatedStore) ListByCategory(categoryID string) ([]models.Nominated, error) {
	log.Printf("sqlnominatedstore: ListByCategory(category=%s) start", categoryID)
	qry := `SELECT id, movie_id, category_id, nominee_name, url_image
FROM nominees
WHERE category_id = $1
ORDER BY created_at DESC
LIMIT 100`
	rows, err := s.db.Query(qry, categoryID)
	if err != nil {
		log.Printf("sqlnominatedstore: ListByCategory query error: %v", err)
		return nil, err
	}
	defer rows.Close()

	out := make([]models.Nominated, 0)
	i := 0
	for rows.Next() {
		var n models.Nominated
		var name sql.NullString
		var url sql.NullString
		if err := rows.Scan(&n.ID, &n.MovieID, &n.CategoryID, &name, &url); err != nil {
			log.Printf("sqlnominatedstore: ListByCategory scan error at row %d: %v", i, err)
			return nil, err
		}
		if name.Valid {
			n.Name = name.String
		} else {
			n.Name = ""
		}
		if url.Valid {
			n.UrlImage = url.String
		} else {
			n.UrlImage = ""
		}
		log.Printf("sqlnominatedstore: ListByCategory scanned row %d: id=%s movie_id=%s category_id=%s", i, n.ID, n.MovieID, n.CategoryID)
		out = append(out, n)
		i++
	}

	if err := rows.Err(); err != nil {
		log.Printf("sqlnominatedstore: ListByCategory rows.Err: %v", err)
		return nil, err
	}

	log.Printf("sqlnominatedstore: ListByCategory complete, scanned %d rows", i)
	return out, nil
}
