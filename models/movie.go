package models

// Movie represents a movie with UUID id and Title fields.
type Movie struct {
	ID    string `json:"id,omitempty"`
	Title string `json:"title"`
}
