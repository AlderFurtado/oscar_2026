package models

import "time"

// User represents an application user. PasswordHash is omitted from JSON responses.
type User struct {
	ID           string    `json:"id,omitempty"`
	Nickname     string    `json:"nickname"`
	Bio          *string   `json:"bio,omitempty"`
	Email        string    `json:"email"`
	PasswordHash string    `json:"-"`
	CreatedAt    time.Time `json:"created_at,omitempty"`
}
