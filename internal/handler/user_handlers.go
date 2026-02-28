package handler

import (
	"encoding/json"
	"io"
	"net/http"
	"time"

	"votacao/models"

	"golang.org/x/crypto/bcrypt"
)

// Register accepts POST /register with JSON {nickname, email, password, bio?}
// It hashes the password and creates a new user.
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()
	var req struct {
		Nickname string  `json:"nickname"`
		Email    string  `json:"email"`
		Password string  `json:"password"`
		Bio      *string `json:"bio,omitempty"`
	}
	if err := json.Unmarshal(body, &req); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if req.Nickname == "" || req.Email == "" || req.Password == "" {
		http.Error(w, "nickname, email and password are required", http.StatusBadRequest)
		return
	}
	// hash password
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), 12)
	if err != nil {
		http.Error(w, "failed to hash password", http.StatusInternalServerError)
		return
	}
	u := &models.User{
		Nickname:     req.Nickname,
		Email:        req.Email,
		Bio:          req.Bio,
		PasswordHash: string(hash),
		CreatedAt:    time.Now(),
	}
	id, err := h.userStore.Insert(u)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	u.ID = id
	// respond with limited user info
	out := struct {
		ID        string    `json:"id"`
		Nickname  string    `json:"nickname"`
		Email     string    `json:"email"`
		Bio       *string   `json:"bio,omitempty"`
		CreatedAt time.Time `json:"created_at"`
	}{ID: u.ID, Nickname: u.Nickname, Email: u.Email, Bio: u.Bio, CreatedAt: u.CreatedAt}

	// Optionally set JWT cookie on successful registration so user is logged in
	tok, _ := h.generateToken(u)
	cookie := &http.Cookie{
		Name:     "jwt",
		Value:    tok,
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
		Secure:   cookieSecure(),
		Expires:  time.Now().Add(24 * time.Hour),
	}
	http.SetCookie(w, cookie)
	// ensure csrf cookie for double-submit pattern
	h.ensureCSRFCookie(w, r)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	_ = json.NewEncoder(w).Encode(out)
}

// Login accepts POST /login with JSON {email, password} and returns {token: "..."}
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "failed to read body", http.StatusBadRequest)
		return
	}
	defer r.Body.Close()
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.Unmarshal(body, &req); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if req.Email == "" || req.Password == "" {
		http.Error(w, "email and password are required", http.StatusBadRequest)
		return
	}
	u, err := h.userStore.GetByEmail(req.Email)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if u == nil {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}
	if err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(req.Password)); err != nil {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}
	tok, err := h.generateToken(u)
	if err != nil {
		http.Error(w, "failed to generate token: "+err.Error(), http.StatusInternalServerError)
		return
	}
	// set HttpOnly cookie with JWT
	cookie := &http.Cookie{
		Name:     "jwt",
		Value:    tok,
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
		Secure:   cookieSecure(),
		Expires:  time.Now().Add(24 * time.Hour),
	}
	http.SetCookie(w, cookie)
	// ensure csrf cookie for double-submit pattern
	h.ensureCSRFCookie(w, r)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

// Logout clears the auth cookie and redirects to the login page
func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	cookie := &http.Cookie{
		Name:     "jwt",
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		Expires:  time.Unix(0, 0),
		MaxAge:   -1,
		Secure:   cookieSecure(),
	}
	http.SetCookie(w, cookie)
	http.Redirect(w, r, "/login/new", http.StatusSeeOther)
}

// Me returns current user info; requires authentication via RequireAuth middleware.
func (h *Handler) Me(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	uid, ok := GetUserIDFromContext(r.Context())
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}
	u, err := h.userStore.GetByID(uid)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if u == nil {
		http.Error(w, "user not found", http.StatusNotFound)
		return
	}
	out := struct {
		ID        string    `json:"id"`
		Nickname  string    `json:"nickname"`
		Email     string    `json:"email"`
		Bio       *string   `json:"bio,omitempty"`
		CreatedAt time.Time `json:"created_at"`
	}{ID: u.ID, Nickname: u.Nickname, Email: u.Email, Bio: u.Bio, CreatedAt: u.CreatedAt}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}
