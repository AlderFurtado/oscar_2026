package models

import "time"

// Vote represents a user's vote for a nominated candidate in a category.
// Note: Vote.ID remains an integer (serial) while referenced IDs are UUID strings.
type Vote struct {
	ID          int64     `json:"id,omitempty"`
	UserID      string    `json:"user_id"`
	NominatedID string    `json:"nominated_id"`
	CategoryID  string    `json:"category_id"`
	CreatedAt   time.Time `json:"created_at,omitempty"`
}
