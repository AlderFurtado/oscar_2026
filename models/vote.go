package models

import "time"

// Vote represents a user's vote for a nominated candidate in a category.
type Vote struct {
	ID          int64     `json:"id,omitempty"`
	UserID      string    `json:"user_id"`
	NominatedID int64     `json:"nominated_id"`
	CategoryID  int64     `json:"category_id"`
	CreatedAt   time.Time `json:"created_at,omitempty"`
}
