package models

// Winner represents a winning nominated entry.
type Winner struct {
	ID          string `json:"id,omitempty"`
	NominatedID string `json:"nominated_id"`
}
