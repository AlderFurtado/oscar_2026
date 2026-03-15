package handler

import (
	"encoding/json"
	"io"
	"net/http"
	"time"

	"votacao/models"
)

// AddVote accepts POST /add_vote and creates a vote for the authenticated user.
// Body: { "nominated_id": <int> }
func (h *Handler) AddVote(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Voting deadline: votes allowed only until 7:00 PM (19:00) UTC-3 on March 15, 2026
	// After that time, voting is closed.
	loc, err := time.LoadLocation("America/Sao_Paulo")
	if err != nil {
		// fallback: use fixed offset UTC-3
		loc = time.FixedZone("UTC-3", -3*60*60)
	}
	if time.Now().In(loc).After(VotingDeadline) {
		http.Error(w, "voting is closed", http.StatusForbidden)
		return
	}

	uid, ok := GetUserIDFromContext(r.Context())
	if !ok || uid == "" {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	// ensure the user exists (DB may have been reset)
	if h.userStore != nil {
		if u, err := h.userStore.GetByID(uid); err != nil {
			http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
			return
		} else if u == nil {
			http.Error(w, "unauthorized: user not found", http.StatusUnauthorized)
			return
		}
	}
	// validate CSRF token (double-submit cookie)
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
		NominatedID string `json:"nominated_id"`
	}
	if err := json.Unmarshal(body, &req); err != nil {
		http.Error(w, "invalid json: "+err.Error(), http.StatusBadRequest)
		return
	}
	if req.NominatedID == "" {
		http.Error(w, "nominated_id is required", http.StatusBadRequest)
		return
	}
	nom, err := h.nominatedStore.Get(req.NominatedID)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	if nom == nil {
		http.Error(w, "nominated not found", http.StatusBadRequest)
		return
	}
	v := &models.Vote{UserID: uid, NominatedID: req.NominatedID, CategoryID: nom.CategoryID}
	id, created, err := h.voteStore.Insert(v)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	v.ID = id
	w.Header().Set("Content-Type", "application/json")
	if created {
		w.WriteHeader(http.StatusCreated)
	} else {
		w.WriteHeader(http.StatusOK)
	}
	out := struct {
		Created bool        `json:"created"`
		Vote    models.Vote `json:"vote"`
	}{Created: created, Vote: *v}
	_ = json.NewEncoder(w).Encode(out)
}

// ListVotes returns votes for the authenticated user.
func (h *Handler) ListVotes(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	uid, ok := GetUserIDFromContext(r.Context())
	if !ok || uid == "" {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}
	out, err := h.voteStore.ListByUser(uid)
	if err != nil {
		http.Error(w, "db error: "+err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

// VotingDeadline is the shared deadline used by AddVote and GetDeadline.
var VotingDeadline = func() time.Time {
	loc, err := time.LoadLocation("America/Sao_Paulo")
	if err != nil {
		loc = time.FixedZone("UTC-3", -3*60*60)
	}
	return time.Date(2026, time.March, 15, 19, 0, 0, 0, loc)
}()

// GetDeadline returns the voting deadline as JSON so the frontend can display a countdown.
// GET /deadline -> { "deadline": "2026-03-15T00:00:00-03:00", "server_time": "...", "closed": bool }
func (h *Handler) GetDeadline(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	loc, _ := time.LoadLocation("America/Sao_Paulo")
	if loc == nil {
		loc = time.FixedZone("UTC-3", -3*60*60)
	}
	now := time.Now().In(loc)
	out := struct {
		Deadline   string `json:"deadline"`
		ServerTime string `json:"server_time"`
		Closed     bool   `json:"closed"`
	}{
		Deadline:   VotingDeadline.Format(time.RFC3339),
		ServerTime: now.Format(time.RFC3339),
		Closed:     now.After(VotingDeadline),
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}
