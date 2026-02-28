package models

// Nominated represents a nomination linking a movie and a category with a name.
type Nominated struct {
	ID         int64  `json:"id,omitempty"`
	MovieID    int64  `json:"movie_id"`
	CategoryID int64  `json:"category_id"`
	Name       string `json:"name"`
}
