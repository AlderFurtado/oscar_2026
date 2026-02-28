package models

// Category represents a simple category with ID and Name.
type Category struct {
	ID   int64  `json:"id,omitempty"`
	Name string `json:"name"`
}
