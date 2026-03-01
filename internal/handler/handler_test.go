package handler

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"votacao/models"
)

type mockMovieStore struct{}

func (m *mockMovieStore) Insert(mv *models.Movie) (string, error) {
	return "00000000-0000-0000-0000-000000000042", nil
}
func (m *mockMovieStore) Get(id string) (*models.Movie, error) {
	if id != "00000000-0000-0000-0000-000000000042" {
		return nil, nil
	}
	return &models.Movie{ID: "00000000-0000-0000-0000-000000000042", Title: "Mock"}, nil
}
func (m *mockMovieStore) List() ([]models.Movie, error) {
	return []models.Movie{{ID: "00000000-0000-0000-0000-000000000042", Title: "Mock"}}, nil
}

func (m *mockMovieStore) InsertMany(ms []models.Movie) ([]string, error) {
	ids := make([]string, 0, len(ms))
	for i := range ms {
		ids = append(ids, fmt.Sprintf("00000000-0000-0000-0000-0000000001%02d", i))
	}
	return ids, nil
}

type mockCategoryStore struct{}

func (m *mockCategoryStore) Insert(c *models.Category) (string, error) {
	return "00000000-0000-0000-0000-000000000007", nil
}
func (m *mockCategoryStore) Get(id string) (*models.Category, error) {
	if id != "00000000-0000-0000-0000-000000000007" {
		return nil, nil
	}
	return &models.Category{ID: "00000000-0000-0000-0000-000000000007", Name: "MockCat"}, nil
}
func (m *mockCategoryStore) List() ([]models.Category, error) {
	return []models.Category{{ID: "00000000-0000-0000-0000-000000000007", Name: "MockCat"}}, nil
}
func (m *mockCategoryStore) InsertMany(cs []models.Category) ([]string, error) {
	ids := make([]string, 0, len(cs))
	for i := range cs {
		ids = append(ids, fmt.Sprintf("00000000-0000-0000-0000-0000000002%02d", i))
	}
	return ids, nil
}

type mockNominatedStore struct{}

func (m *mockNominatedStore) Insert(n *models.Nominated) (string, error) {
	return "00000000-0000-0000-0000-000000000011", nil
}
func (m *mockNominatedStore) InsertMany(ns []models.Nominated) ([]string, error) {
	ids := make([]string, 0, len(ns))
	for i := range ns {
		ids = append(ids, fmt.Sprintf("00000000-0000-0000-0000-0000000003%02d", i))
	}
	return ids, nil
}
func (m *mockNominatedStore) Get(id string) (*models.Nominated, error) {
	if id != "00000000-0000-0000-0000-000000000011" {
		return nil, nil
	}
	return &models.Nominated{ID: "00000000-0000-0000-0000-000000000011", MovieID: "1", CategoryID: "1", Name: "Nominee"}, nil
}
func (m *mockNominatedStore) List() ([]models.Nominated, error) {
	return []models.Nominated{{ID: "00000000-0000-0000-0000-000000000011", MovieID: "1", CategoryID: "1", Name: "Nominee"}}, nil
}

type mockUserStore struct{}

func (m *mockUserStore) Insert(u *models.User) (string, error) {
	return "00000000-0000-0000-0000-000000000000", nil
}
func (m *mockUserStore) GetByID(id string) (*models.User, error)       { return nil, nil }
func (m *mockUserStore) GetByEmail(email string) (*models.User, error) { return nil, nil }
func (m *mockUserStore) List() ([]models.User, error)                  { return []models.User{}, nil }

type mockVoteStore struct{}

func (m *mockVoteStore) Insert(v *models.Vote) (int64, bool, error)      { return 123, true, nil }
func (m *mockVoteStore) Get(id int64) (*models.Vote, error)              { return nil, nil }
func (m *mockVoteStore) ListByUser(userID string) ([]models.Vote, error) { return []models.Vote{}, nil }

func TestAddMovie(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	payload := models.Movie{Title: "T"}
	b, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "/add_movie", bytes.NewReader(b))
	// include CSRF token cookie and header to satisfy validateCSRF in handlers
	req.AddCookie(&http.Cookie{Name: "csrf_token", Value: "testcsrf"})
	req.Header.Set("X-CSRF-Token", "testcsrf")
	rr := httptest.NewRecorder()
	h.AddMovie(rr, req)
	if rr.Code != http.StatusCreated {
		t.Fatalf("expected 201 got %d, body=%s", rr.Code, rr.Body.String())
	}
	var got models.Movie
	if err := json.Unmarshal(rr.Body.Bytes(), &got); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	if got.ID != "00000000-0000-0000-0000-000000000042" {
		t.Fatalf("expected id 000...42 got %s", got.ID)
	}
}

func TestListAndGet(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	rr := httptest.NewRecorder()
	req := httptest.NewRequest(http.MethodGet, "/movies", nil)
	h.ListMovies(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("list: expected 200 got %d", rr.Code)
	}
	rr = httptest.NewRecorder()
	req = httptest.NewRequest(http.MethodGet, "/movies?id=42", nil)
	h.GetMovie(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("get: expected 200 got %d", rr.Code)
	}
}

func TestAddCategory(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	payload := models.Category{Name: "C"}
	b, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "/add_category", bytes.NewReader(b))
	// include CSRF token cookie and header to satisfy validateCSRF in handlers
	req.AddCookie(&http.Cookie{Name: "csrf_token", Value: "testcsrf"})
	req.Header.Set("X-CSRF-Token", "testcsrf")
	rr := httptest.NewRecorder()
	h.AddCategory(rr, req)
	if rr.Code != http.StatusCreated {
		t.Fatalf("expected 201 got %d, body=%s", rr.Code, rr.Body.String())
	}
	var got models.Category
	if err := json.Unmarshal(rr.Body.Bytes(), &got); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	if got.ID != "00000000-0000-0000-0000-000000000007" {
		t.Fatalf("expected id 000...07 got %s", got.ID)
	}
}

func TestListAndGetCategories(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	rr := httptest.NewRecorder()
	req := httptest.NewRequest(http.MethodGet, "/categories", nil)
	h.ListCategories(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("list categories: expected 200 got %d", rr.Code)
	}
	rr = httptest.NewRecorder()
	req = httptest.NewRequest(http.MethodGet, "/categories?id=7", nil)
	h.GetCategory(rr, req)
	if rr.Code != http.StatusOK {
		t.Fatalf("get category: expected 200 got %d", rr.Code)
	}
}

func TestAddCategories(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	payload := []models.Category{{Name: "A"}, {Name: "B"}}
	b, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "/add_categories", bytes.NewReader(b))
	// include CSRF token cookie and header to satisfy validateCSRF in handlers
	req.AddCookie(&http.Cookie{Name: "csrf_token", Value: "testcsrf"})
	req.Header.Set("X-CSRF-Token", "testcsrf")
	rr := httptest.NewRecorder()
	h.AddCategories(rr, req)
	if rr.Code != http.StatusCreated {
		t.Fatalf("expected 201 got %d, body=%s", rr.Code, rr.Body.String())
	}
	var got []models.Category
	if err := json.Unmarshal(rr.Body.Bytes(), &got); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	if len(got) != 2 {
		t.Fatalf("expected 2 categories got %d", len(got))
	}
	if got[0].ID == "" || got[1].ID == "" {
		t.Fatalf("expected assigned ids, got %+v", got)
	}
}

func TestAddMovies(t *testing.T) {
	h := New(&mockMovieStore{}, &mockCategoryStore{}, &mockNominatedStore{}, &mockUserStore{}, &mockVoteStore{}, nil, "devsecret")
	payload := []models.Movie{{Title: "A"}, {Title: "B"}}
	b, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "/add_movies", bytes.NewReader(b))
	// include CSRF token cookie and header to satisfy validateCSRF in handlers
	req.AddCookie(&http.Cookie{Name: "csrf_token", Value: "testcsrf"})
	req.Header.Set("X-CSRF-Token", "testcsrf")
	rr := httptest.NewRecorder()
	h.AddMovies(rr, req)
	if rr.Code != http.StatusCreated {
		t.Fatalf("expected 201 got %d, body=%s", rr.Code, rr.Body.String())
	}
	var got []models.Movie
	if err := json.Unmarshal(rr.Body.Bytes(), &got); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	if len(got) != 2 {
		t.Fatalf("expected 2 movies got %d", len(got))
	}
	if got[0].ID == "" || got[1].ID == "" {
		t.Fatalf("expected assigned ids, got %+v", got)
	}
}
