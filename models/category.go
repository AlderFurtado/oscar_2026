package models

// Category represents a simple category with UUID and Name.
type Category struct {
	ID   string `json:"id,omitempty"`
	Name string `json:"name"`
}
