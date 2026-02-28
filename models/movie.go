package models

// Movie represents a movie with only ID and Title fields.
type Movie struct {
	ID    int64  `json:"id,omitempty"`
	Title string `json:"title"`
}
