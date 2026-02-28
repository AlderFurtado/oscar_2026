package handler

import (
	"encoding/json"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"strconv"
	"strings"

	"votacao/internal/store"
	"votacao/models"
)

type Handler struct {
	movieStore     store.MovieStore
	categoryStore  store.CategoryStore
	nominatedStore store.NominatedStore
	userStore      store.UserStore
	voteStore      store.VoteStore
	nominatedTpl   *template.Template
	jwtSecret      string
}

func New(m store.MovieStore, c store.CategoryStore, n store.NominatedStore, u store.UserStore, v store.VoteStore, tpl *template.Template, jwtSecret string) *Handler {
	return &Handler{movieStore: m, categoryStore: c, nominatedStore: n, userStore: u, voteStore: v, nominatedTpl: tpl, jwtSecret: jwtSecret}
}

// AddMovie accepts POST /add_movie with JSON body and inserts into storage.
func (h *Handler) AddMovie(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// validate CSRF for mutating request
	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}

	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	var m models.Movie
	if err := json.Unmarshal(body, &m); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if m.Title == "" {
		http.Error(w, "title is required", http.StatusBadRequest)
		return
	}

	id, err := h.movieStore.Insert(&m)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	m.ID = id
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(m)
}

// AddMovies accepts POST /add_movies with a JSON array body and inserts multiple movies.
func (h *Handler) AddMovies(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	var ms []models.Movie
	if err := json.Unmarshal(body, &ms); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if len(ms) == 0 {
		http.Error(w, "empty movie list", http.StatusBadRequest)
		return
	}
	// basic validation
	for i := range ms {
		if ms[i].Title == "" {
			http.Error(w, "title is required for each movie", http.StatusBadRequest)
			return
		}
	}

	ids, err := h.movieStore.InsertMany(ms)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	// attach IDs to returned objects
	out := make([]models.Movie, 0, len(ms))
	for i := range ms {
		m := ms[i]
		if i < len(ids) {
			m.ID = ids[i]
		}
		out = append(out, m)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(out)
}

// ListMovies handles GET /movies
func (h *Handler) ListMovies(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	out, err := h.movieStore.List()
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

// GetMovie handles GET /movies?id=<id>
func (h *Handler) GetMovie(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	q := r.URL.Query().Get("id")
	if q == "" {
		http.Error(w, "id is required", http.StatusBadRequest)
		return
	}
	id, err := strconv.ParseInt(q, 10, 64)
	if err != nil {
		http.Error(w, "invalid id", http.StatusBadRequest)
		return
	}
	m, err := h.movieStore.Get(id)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if m == nil {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(m)
}

// AddCategory accepts POST /add_category with JSON body and inserts into storage.
func (h *Handler) AddCategory(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	var c models.Category
	if err := json.Unmarshal(body, &c); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if c.Name == "" {
		http.Error(w, "name is required", http.StatusBadRequest)
		return
	}
	id, err := h.categoryStore.Insert(&c)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	c.ID = id
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(c)
}

// AddCategories accepts POST /add_categories with a JSON array body and inserts multiple categories.
func (h *Handler) AddCategories(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	var cs []models.Category
	if err := json.Unmarshal(body, &cs); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if len(cs) == 0 {
		http.Error(w, "empty category list", http.StatusBadRequest)
		return
	}
	for i := range cs {
		if cs[i].Name == "" {
			http.Error(w, "name is required for each category", http.StatusBadRequest)
			return
		}
	}
	ids, err := h.categoryStore.InsertMany(cs)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	out := make([]models.Category, 0, len(cs))
	for i := range cs {
		c := cs[i]
		if i < len(ids) {
			c.ID = ids[i]
		}
		out = append(out, c)
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(out)
}

// AddNominated accepts POST /add_nominated with JSON body and inserts into storage.
func (h *Handler) AddNominated(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	// Accept either movie_id or movie_name in the request JSON.
	var in struct {
		MovieID   int64  `json:"movie_id,omitempty"`
		MovieName string `json:"movie_name,omitempty"`
		CategoryID int64 `json:"category_id"`
		Name      string `json:"name"`
	}
	if err := json.Unmarshal(body, &in); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if (in.MovieID == 0 && strings.TrimSpace(in.MovieName) == "") || in.CategoryID == 0 || in.Name == "" {
		http.Error(w, "movie_id or movie_name, category_id and name are required", http.StatusBadRequest)
		return
	}
	// resolve movie id by name if needed
	if in.MovieID == 0 {
		// try to find by title
		m, err := h.movieStore.GetByTitle(in.MovieName)
		if err != nil {
			http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
			return
		}
		if m == nil {
			// create movie
			mid, err := h.movieStore.Insert(&models.Movie{Title: in.MovieName})
			if err != nil {
				http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
				return
			}
			in.MovieID = mid
		} else {
			in.MovieID = m.ID
		}
	}
	n := models.Nominated{MovieID: in.MovieID, CategoryID: in.CategoryID, Name: in.Name}
	id, err := h.nominatedStore.Insert(&n)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	n.ID = id
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(n)
}

// AddNominateds accepts POST /add_nominateds with a JSON array body and inserts multiple nominations.
func (h *Handler) AddNominateds(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	// Accept array of objects that may contain movie_id or movie_name
	var ins []struct {
		MovieID   int64  `json:"movie_id,omitempty"`
		MovieName string `json:"movie_name,omitempty"`
		CategoryID int64 `json:"category_id"`
		Name      string `json:"name"`
	}
	if err := json.Unmarshal(body, &ins); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if len(ins) == 0 {
		http.Error(w, "empty nomination list", http.StatusBadRequest)
		return
	}
	// Resolve movie ids where needed
	ns := make([]models.Nominated, 0, len(ins))
	for i := range ins {
		it := ins[i]
		if (it.MovieID == 0 && strings.TrimSpace(it.MovieName) == "") || it.CategoryID == 0 || it.Name == "" {
			http.Error(w, "movie_id or movie_name, category_id and name are required for each nomination", http.StatusBadRequest)
			return
		}
		mid := it.MovieID
		if mid == 0 {
			m, err := h.movieStore.GetByTitle(it.MovieName)
			if err != nil {
				http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
				return
			}
			if m == nil {
				nid, err := h.movieStore.Insert(&models.Movie{Title: it.MovieName})
				if err != nil {
					http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
					return
				}
				mid = nid
			} else {
				mid = m.ID
			}
		}
		ns = append(ns, models.Nominated{MovieID: mid, CategoryID: it.CategoryID, Name: it.Name})
	}
	ids, err := h.nominatedStore.InsertMany(ns)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	out := make([]models.Nominated, 0, len(ns))
	for i := range ns {
		n := ns[i]
		if i < len(ids) {
			n.ID = ids[i]
		}
		out = append(out, n)
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(out)
}

// ListNominateds handles GET /nominateds
func (h *Handler) ListNominateds(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	out, err := h.nominatedStore.List()
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

// GetNominated handles GET /nominateds?id=<id>
func (h *Handler) GetNominated(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	q := r.URL.Query().Get("id")
	if q == "" {
		http.Error(w, "id is required", http.StatusBadRequest)
		return
	}
	id, err := strconv.ParseInt(q, 10, 64)
	if err != nil {
		http.Error(w, "invalid id", http.StatusBadRequest)
		return
	}
	n, err := h.nominatedStore.Get(id)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if n == nil {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(n)
}

// ServeNominatedForm renders an HTML form to create a nomination by selecting
// a movie and a category and entering a name. The form POSTs to /nominated/create.
func (h *Handler) ServeNominatedForm(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	movies, err := h.movieStore.List()
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	categories, err := h.categoryStore.List()
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	csrf := h.ensureCSRFCookie(w, r)
	data := struct {
		Movies     []models.Movie
		Categories []models.Category
		CSRF       string
	}{Movies: movies, Categories: categories, CSRF: csrf}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if h.nominatedTpl != nil {
		if err := h.nominatedTpl.Execute(w, data); err != nil {
			http.Error(w, "template render error: "+err.Error(), http.StatusInternalServerError)
			return
		}
		return
	}
	// fallback: parse template on each request if not provided at startup
	tpl, err := template.ParseFiles("templates/nominated_form.html")
	if err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if err := tpl.Execute(w, data); err != nil {
		http.Error(w, "template render error: "+err.Error(), http.StatusInternalServerError)
		return
	}
}

// CreateNominatedFromForm accepts form POST from the HTML view and creates a nomination.
// It expects form fields: movie_id, category_id, name. On success it redirects to /nominateds.
func (h *Handler) CreateNominatedFromForm(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	// validate csrf token submitted in form
	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}
	if err := r.ParseForm(); err != nil {
		http.Error(w, "invalid form: "+err.Error(), http.StatusBadRequest)
		return
	}
	movieIDStr := r.FormValue("movie_id")
	categoryIDStr := r.FormValue("category_id")
	name := r.FormValue("name")
	if movieIDStr == "" || categoryIDStr == "" || name == "" {
		http.Error(w, "movie_id, category_id and name are required", http.StatusBadRequest)
		return
	}
	movieID, err := strconv.ParseInt(movieIDStr, 10, 64)
	if err != nil {
		http.Error(w, "invalid movie_id", http.StatusBadRequest)
		return
	}
	categoryID, err := strconv.ParseInt(categoryIDStr, 10, 64)
	if err != nil {
		http.Error(w, "invalid category_id", http.StatusBadRequest)
		return
	}
	n := models.Nominated{MovieID: movieID, CategoryID: categoryID, Name: name}
	id, err := h.nominatedStore.Insert(&n)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	// Redirect to list view after successful creation
	http.Redirect(w, r, "/nominateds", http.StatusSeeOther)
	fmt.Printf("created nomination id=%d\n", id)
}

// AddNominatedsByNames accepts POST /add_nominateds_names with JSON { category_id: <int>, names: ["name1","name2"] }
// It will create movies for each provided name (using Movie titles), then create nominated entries linking the created movies to the given category.
func (h *Handler) AddNominatedsByNames(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	if !h.validateCSRF(r) {
		http.Error(w, "invalid csrf token", http.StatusForbidden)
		return
	}

	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()

	var req struct {
		CategoryID int64    `json:"category_id"`
		Names      []string `json:"names"`
	}
	if err := json.Unmarshal(body, &req); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if req.CategoryID == 0 || len(req.Names) == 0 {
		http.Error(w, "category_id and non-empty names are required", http.StatusBadRequest)
		return
	}

	// verify category exists
	cat, err := h.categoryStore.Get(req.CategoryID)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if cat == nil {
		http.Error(w, "category not found", http.StatusBadRequest)
		return
	}

	// create movie rows for each name
	movies := make([]models.Movie, 0, len(req.Names))
	for _, n := range req.Names {
		if n == "" {
			http.Error(w, "empty name in list", http.StatusBadRequest)
			return
		}
		movies = append(movies, models.Movie{Title: n})
	}
	ids, err := h.movieStore.InsertMany(movies)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// create nominated entries
	nominateds := make([]models.Nominated, 0, len(ids))
	for i, mid := range ids {
		nominateds = append(nominateds, models.Nominated{MovieID: mid, CategoryID: req.CategoryID, Name: req.Names[i]})
	}
	nids, err := h.nominatedStore.InsertMany(nominateds)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// attach IDs to response
	out := make([]models.Nominated, 0, len(nominateds))
	for i := range nominateds {
		n := nominateds[i]
		if i < len(nids) {
			n.ID = nids[i]
		}
		out = append(out, n)
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(out)
}

// ServeLoginForm renders a simple login/register HTML form.
func (h *Handler) ServeLoginForm(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	// ensure CSRF cookie so the client can include it in subsequent requests
	h.ensureCSRFCookie(w, r)
	// fallback: parse template on each request
	tpl, err := template.ParseFiles("templates/login_form.html", "templates/auth_modal.html")
	if err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := tpl.Execute(w, nil); err != nil {
		http.Error(w, "template render error: "+err.Error(), http.StatusInternalServerError)
		return
	}
}

// ServeCategoriesView renders the categories page which fetches the API using the stored JWT.
func (h *Handler) ServeCategoriesView(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	// try to load compiled template or parse from templates dir
	tpl, err := template.ParseFiles("templates/categories_view.html")
	if err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := tpl.Execute(w, nil); err != nil {
		http.Error(w, "template render error: "+err.Error(), http.StatusInternalServerError)
		return
	}
}

// ServeNominatedsView renders a page showing nominated candidates for a category.
func (h *Handler) ServeNominatedsView(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	tpl, err := template.ParseFiles("templates/nominateds_view.html", "templates/auth_modal.html")
	if err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := tpl.Execute(w, nil); err != nil {
		http.Error(w, "template render error: "+err.Error(), http.StatusInternalServerError)
		return
	}
}

// ListCategories handles GET /categories
func (h *Handler) ListCategories(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	out, err := h.categoryStore.List()
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

// GetCategory handles GET /categories?id=<id>
func (h *Handler) GetCategory(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	q := r.URL.Query().Get("id")
	if q == "" {
		http.Error(w, "id is required", http.StatusBadRequest)
		return
	}
	id, err := strconv.ParseInt(q, 10, 64)
	if err != nil {
		http.Error(w, "invalid id", http.StatusBadRequest)
		return
	}
	c, err := h.categoryStore.Get(id)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if c == nil {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(c)
}
