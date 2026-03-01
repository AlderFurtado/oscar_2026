package handler

import (
	"encoding/json"
	"io"
	"net/http"

	"votacao/models"
)

// AddVote accepts POST /add_vote and creates a vote for the authenticated user.
// Body: { "nominated_id": <int> }
func (h *Handler) AddVote(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	uid, ok := GetUserIDFromContext(r.Context())
	if !ok || uid == "" {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
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
