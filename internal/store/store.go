package store

import "votacao/models"

// MovieStore defines storage operations for movies.
type MovieStore interface {
	Insert(m *models.Movie) (string, error)
	Get(id string) (*models.Movie, error)
	List() ([]models.Movie, error)
	// InsertMany inserts multiple movies and returns their assigned IDs in the same order.
	InsertMany(ms []models.Movie) ([]string, error)
}

// CategoryStore defines storage operations for categories.
type CategoryStore interface {
	// Insert inserts a single category and returns its assigned ID.
	Insert(c *models.Category) (string, error)
	// Get returns a category by id or nil if not found.
	Get(id string) (*models.Category, error)
	// List returns categories (up to 100 by default).
	List() ([]models.Category, error)
	// InsertMany inserts multiple categories and returns their assigned IDs in the same order.
	InsertMany(cs []models.Category) ([]string, error)
}

// MovieCategoryStore aggregates movie and category operations for convenience.
// Note: we intentionally do not provide a single combined interface that embeds
// both MovieStore and CategoryStore because both interfaces use the same method
// names (Insert/Get/List/InsertMany) with different argument types. A single
// concrete type cannot implement both sets of methods due to Go's method naming
// rules. Instead, create separate concrete stores for movies and categories
// and pass them separately to callers that need both.

// NominatedStore defines storage operations for nominations linking movies and categories.
type NominatedStore interface {
	// Insert inserts a single nomination and returns its assigned ID.
	Insert(n *models.Nominated) (string, error)
	// InsertMany inserts multiple nominations and returns their assigned IDs in the same order.
	InsertMany(ns []models.Nominated) ([]string, error)
	// Get returns a nomination by id or nil if not found.
	Get(id string) (*models.Nominated, error)
	// List returns nominations (up to 100 by default).
	List() ([]models.Nominated, error)
}

// UserStore defines storage operations for application users.
type UserStore interface {
	// Insert inserts a new user and returns the assigned UUID string.
	Insert(u *models.User) (string, error)
	// GetByID returns a user by UUID or nil if not found.
	GetByID(id string) (*models.User, error)
	// GetByEmail returns a user by email or nil if not found.
	GetByEmail(email string) (*models.User, error)
	// List returns users (up to 100 by default).
	List() ([]models.User, error)
}

// VoteStore defines storage operations for votes.
type VoteStore interface {
	// Insert inserts or updates a vote and returns its assigned ID and a
	// boolean indicating whether a new row was created (true) or an
	// existing vote was updated (false).
	Insert(v *models.Vote) (int64, bool, error)
	// Get returns a vote by id or nil if not found.
	Get(id int64) (*models.Vote, error)
	// ListByUser returns votes for a given user UUID.
	ListByUser(userID string) ([]models.Vote, error)
}
