package store

import (
	"database/sql"
	"fmt"
	"time"

	"votacao/models"

	"github.com/google/uuid"
)

type SQLUserStore struct{ db *sql.DB }

func NewSQLUser(db *sql.DB) *SQLUserStore { return &SQLUserStore{db: db} }

func (s *SQLUserStore) Insert(u *models.User) (string, error) {
	if u.ID == "" {
		u.ID = uuid.NewString()
	}
	if u.CreatedAt.IsZero() {
		u.CreatedAt = time.Now()
	}
	// Default role to "user" if not set
	if u.Role == "" {
		u.Role = "user"
	}
	_, err := s.db.Exec("INSERT INTO users (id, nickname, bio, email, password_hash, role, created_at) VALUES ($1,$2,$3,$4,$5,$6,$7)",
		u.ID, u.Nickname, u.Bio, u.Email, u.PasswordHash, u.Role, u.CreatedAt)
	if err != nil {
		return "", fmt.Errorf("insert user: %w", err)
	}
	return u.ID, nil
}

func (s *SQLUserStore) GetByID(id string) (*models.User, error) {
	var u models.User
	var bio sql.NullString
	var role sql.NullString
	row := s.db.QueryRow("SELECT id, nickname, bio, email, password_hash, role, created_at FROM users WHERE id=$1", id)
	if err := row.Scan(&u.ID, &u.Nickname, &bio, &u.Email, &u.PasswordHash, &role, &u.CreatedAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get user: %w", err)
	}
	if bio.Valid {
		u.Bio = &bio.String
	}
	if role.Valid {
		u.Role = role.String
	} else {
		u.Role = "user"
	}
	return &u, nil
}

func (s *SQLUserStore) GetByEmail(email string) (*models.User, error) {
	var u models.User
	var bio sql.NullString
	var role sql.NullString
	row := s.db.QueryRow("SELECT id, nickname, bio, email, password_hash, role, created_at FROM users WHERE email=$1", email)
	if err := row.Scan(&u.ID, &u.Nickname, &bio, &u.Email, &u.PasswordHash, &role, &u.CreatedAt); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("get by email: %w", err)
	}
	if bio.Valid {
		u.Bio = &bio.String
	}
	if role.Valid {
		u.Role = role.String
	} else {
		u.Role = "user"
	}
	return &u, nil
}

func (s *SQLUserStore) List() ([]models.User, error) {
	rows, err := s.db.Query("SELECT id, nickname, bio, email, password_hash, role, created_at FROM users ORDER BY created_at DESC LIMIT 100")
	if err != nil {
		return nil, fmt.Errorf("list users: %w", err)
	}
	defer rows.Close()
	out := make([]models.User, 0)
	for rows.Next() {
		var u models.User
		var bio sql.NullString
		var role sql.NullString
		if err := rows.Scan(&u.ID, &u.Nickname, &bio, &u.Email, &u.PasswordHash, &role, &u.CreatedAt); err != nil {
			return nil, fmt.Errorf("scan user: %w", err)
		}
		if bio.Valid {
			u.Bio = &bio.String
		}
		if role.Valid {
			u.Role = role.String
		} else {
			u.Role = "user"
		}
		out = append(out, u)
	}
	return out, nil
}
