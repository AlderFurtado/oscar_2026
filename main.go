package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"

	_ "github.com/lib/pq"

	"votacao/internal/db"
	"votacao/internal/handler"
	"votacao/internal/store"
)

func main() {
	// Prefer a full DATABASE_URL (postgresql://...) if provided. Otherwise
	// build a lib/pq style DSN from individual PG_* environment variables.
	dsn := envOr("DATABASE_URL", "")
	if dsn == "" {
		dsn = fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
			envOr("PG_HOST", "localhost"),
			envOr("PG_PORT", "5432"),
			envOr("PG_USER", "postgres"),
			envOr("PG_PASSWORD", "postgres"),
			envOr("PG_DB", "moviesdb"),
		)
	}

	database, err := db.Open(dsn)
	if err != nil {
		log.Fatalf("failed to open db: %v", err)
	}
	defer database.Close()

	// wire store and handlers
	s := store.NewSQL(database)
	cs := store.NewSQLCategory(database)
	ns := store.NewSQLNominated(database)
	us := store.NewSQLUser(database)
	vs := store.NewSQLVote(database)
	ws := store.NewSQLWinnerStore(database)
	// parse and cache nominated form template at startup
	// try env var TEMPLATE_DIR, then relative "templates/", then absolute "/templates/"
	var tpl *template.Template
	var parseErr error
	tryPaths := []string{}
	if td := os.Getenv("TEMPLATE_DIR"); td != "" {
		tryPaths = append(tryPaths, filepath.Join(td, "nominated_form.html"))
	}
	tryPaths = append(tryPaths, "templates/nominated_form.html", "/templates/nominated_form.html")
	for _, p := range tryPaths {
		if _, err := os.Stat(p); err == nil {
			tpl, parseErr = template.ParseFiles(p)
			if parseErr == nil {
				break
			}
		}
	}
	if tpl == nil && parseErr != nil {
		log.Fatalf("failed to parse template from paths %v: %v", tryPaths, parseErr)
	}
	jwtSecret := envOr("JWT_SECRET", "devsecret")
	h := handler.New(s, cs, ns, us, vs, ws, tpl, jwtSecret)

	http.HandleFunc("/add_movie", h.AddMovie)
	http.HandleFunc("/add_movies", h.AddMovies)
	http.HandleFunc("/add_category", h.AddCategory)
	http.HandleFunc("/add_categories", h.AddCategories)
	http.HandleFunc("/movies", func(w http.ResponseWriter, r *http.Request) {
		// if query param id present, serve GetMovie, else ListMovies
		if r.URL.Query().Get("id") != "" {
			h.GetMovie(w, r)
			return
		}
		h.ListMovies(w, r)
	})

	http.HandleFunc("/categories", func(w http.ResponseWriter, r *http.Request) {
		// if query param id present, serve GetCategory, else ListCategories
		if r.URL.Query().Get("id") != "" {
			h.GetCategory(w, r)
			return
		}
		h.ListCategories(w, r)
	})

	// nomination form and create-from-form endpoints
	http.HandleFunc("/nominated/new", h.ServeNominatedForm)
	http.HandleFunc("/nominated/create", h.CreateNominatedFromForm)
	http.HandleFunc("/login/new", h.ServeLoginForm)
	http.HandleFunc("/categories/view", h.ServeCategoriesView)
	http.HandleFunc("/profile", h.ServeProfileView)
	http.HandleFunc("/users", h.ListUsers)
	http.HandleFunc("/participants", h.ServeParticipantsView)
	http.HandleFunc("/nominateds/view", h.ServeNominatedsView)
	http.HandleFunc("/nominateds/by_category", h.ListNominatedsByCategory)
	http.HandleFunc("/nominees_by_category", h.NomineesByCategory)
	http.HandleFunc("/add_nominateds_names", h.AddNominatedsByNames)
	// JSON API endpoints for nominations
	http.HandleFunc("/add_nominated", h.AddNominated)
	http.HandleFunc("/add_nominateds", h.AddNominateds)
	http.HandleFunc("/nominateds", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("id") != "" {
			h.GetNominated(w, r)
			return
		}
		h.ListNominateds(w, r)
	})

	// auth routes
	http.HandleFunc("/register", h.Register)
	http.HandleFunc("/login", h.Login)
	http.HandleFunc("/logout", h.Logout)
	http.HandleFunc("/me", h.RequireAuth(h.Me))

	// voting routes (require auth)
	http.HandleFunc("/add_vote", h.RequireAuth(h.AddVote))
	http.HandleFunc("/votes", h.RequireAuth(h.ListVotes))

	// score routes
	http.HandleFunc("/score", h.RequireAuth(h.GetMyScore))
	http.HandleFunc("/leaderboard", h.GetLeaderboard)
	http.HandleFunc("/leaderboard/view", h.ServeLeaderboardView)

	// winner routes (admin)
	http.HandleFunc("/winners/view", h.ServeWinnersView)
	http.HandleFunc("/add_winner", h.AddWinner)
	http.HandleFunc("/delete_winner", h.DeleteWinner)
	http.HandleFunc("/winners", h.ListWinners)

	// deadline endpoint (public)
	http.HandleFunc("/deadline", h.GetDeadline)

	// health check
	http.HandleFunc("/healthz", h.Healthz)

	// root -> redirect to categories view
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// redirect home to categories view
		http.Redirect(w, r, "/categories/view", http.StatusSeeOther)
	})

	addr := envOr("HTTP_ADDR", ":8080")
	log.Printf("listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}

func envOr(key, def string) string {
	v := os.Getenv(key)
	if v == "" {
		return def
	}
	return v
}
