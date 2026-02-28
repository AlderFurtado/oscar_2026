package store

import (
	"database/sql"
	"fmt"

	"votacao/models"

	"github.com/lib/pq"
)

type SQLVoteStore struct{ db *sql.DB }

func NewSQLVote(db *sql.DB) *SQLVoteStore { return &SQLVoteStore{db: db} }

// Insert will create or update a vote for a user in a category. If the user
// already voted in the same category, the nominated_id will be updated to the
// new value and the existing vote id is returned. This allows changing votes.
func (s *SQLVoteStore) Insert(v *models.Vote) (int64, bool, error) {
	var id int64
	// Try to insert first
	err := s.db.QueryRow("INSERT INTO votes (user_id, nominated_id, category_id, created_at) VALUES ($1,$2,$3, now()) RETURNING id", v.UserID, v.NominatedID, v.CategoryID).Scan(&id)
	if err == nil {
		return id, true, nil
	}
	// If unique constraint violation, update the existing vote (change nominated)
	if pqErr, ok := err.(*pq.Error); ok && pqErr.Code == "23505" {
		// Update the existing vote for this user/category and return its id
		err2 := s.db.QueryRow("UPDATE votes SET nominated_id=$1, created_at=now() WHERE user_id=$2 AND category_id=$3 RETURNING id", v.NominatedID, v.UserID, v.CategoryID).Scan(&id)
		if err2 != nil {
			return 0, false, fmt.Errorf("update vote after conflict: %w", err2)
		}
		return id, false, nil
	}
	return 0, false, fmt.Errorf("insert vote: %w", err)
}

func (s *SQLVoteStore) Get(id int64) (*models.Vote, error) {
	var v models.Vote
	row := s.db.QueryRow("SELECT id, user_id, nominated_id, category_id, created_at FROM votes WHERE id=$1", id)
	if err := row.Scan(&v.ID, &v.UserID, &v.NominatedID, &v.CategoryID, &v.CreatedAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get vote: %w", err)
	}
	return &v, nil
}

func (s *SQLVoteStore) ListByUser(userID string) ([]models.Vote, error) {
	rows, err := s.db.Query("SELECT id, user_id, nominated_id, category_id, created_at FROM votes WHERE user_id=$1 ORDER BY created_at DESC LIMIT 100", userID)
	if err != nil {
		return nil, fmt.Errorf("list votes: %w", err)
	}
	defer rows.Close()
	out := make([]models.Vote, 0)
	for rows.Next() {
		var v models.Vote
		if err := rows.Scan(&v.ID, &v.UserID, &v.NominatedID, &v.CategoryID, &v.CreatedAt); err != nil {
			return nil, fmt.Errorf("scan vote: %w", err)
		}
		out = append(out, v)
	}
	return out, nil
}
