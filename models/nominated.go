package models

// Nominated represents a nomination linking a movie and a category with a name.
// IDs use UUID strings for movie/category/nominee as defined in the DB migration.
type Nominated struct {
	ID         string `json:"id,omitempty"`
	MovieID    string `json:"movie_id"`
	CategoryID string `json:"category_id"`
	Name       string `json:"name"`
}
