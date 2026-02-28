package handler

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/google/uuid"

	"votacao/models"

	"github.com/golang-jwt/jwt/v5"
)

type ctxKey string

const ctxKeyUserID ctxKey = "user_id"

// generateToken creates a signed JWT for the given user.
func (h *Handler) generateToken(u *models.User) (string, error) {
	if h.jwtSecret == "" {
		return "", errors.New("jwt secret not configured")
	}
	claims := jwt.MapClaims{
		"sub":      u.ID,
		"nickname": u.Nickname,
		"exp":      time.Now().Add(24 * time.Hour).Unix(),
	}
	tok := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return tok.SignedString([]byte(h.jwtSecret))
}

// ensureCSRFCookie ensures a non-HttpOnly csrf_token cookie exists and returns its value.
func (h *Handler) ensureCSRFCookie(w http.ResponseWriter, r *http.Request) string {
	if c, err := r.Cookie("csrf_token"); err == nil && c.Value != "" {
		return c.Value
	}
	tok := uuid.NewString()
	cookie := &http.Cookie{
		Name:     "csrf_token",
		Value:    tok,
		Path:     "/",
		HttpOnly: false,
		SameSite: http.SameSiteLaxMode,
		Secure:   os.Getenv("COOKIE_SECURE") == "true",
		Expires:  time.Now().Add(24 * time.Hour),
	}
	http.SetCookie(w, cookie)
	return tok
}

// validateCSRF compares the X-CSRF-Token header with the csrf_token cookie.
func (h *Handler) validateCSRF(r *http.Request) bool {
	// Accept token from header or from form value (for standard form posts)
	header := r.Header.Get("X-CSRF-Token")
	form := r.FormValue("csrf_token")
	if header == "" && form == "" {
		return false
	}
	val := header
	if val == "" {
		val = form
	}
	c, err := r.Cookie("csrf_token")
	if err != nil {
		return false
	}
	return val == c.Value
}

// cookieSecure returns whether cookies should be marked Secure based on env var.
func cookieSecure() bool {
	return os.Getenv("COOKIE_SECURE") == "true"
}

// RequireAuth is middleware that enforces Bearer token presence and validity.
// On success it stores the user id in the request context under ctxKeyUserID.
func (h *Handler) RequireAuth(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Accept token from either Authorization header or HttpOnly cookie named "jwt"
		tokenStr := ""
		auth := r.Header.Get("Authorization")
		if auth != "" {
			parts := strings.SplitN(auth, " ", 2)
			if len(parts) == 2 && strings.ToLower(parts[0]) == "bearer" {
				tokenStr = parts[1]
			}
		}
		if tokenStr == "" {
			if c, err := r.Cookie("jwt"); err == nil {
				tokenStr = c.Value
			}
		}
		if tokenStr == "" {
			http.Error(w, "authorization required", http.StatusUnauthorized)
			return
		}
		token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method")
			}
			return []byte(h.jwtSecret), nil
		})
		if err != nil || !token.Valid {
			http.Error(w, "invalid token: "+err.Error(), http.StatusUnauthorized)
			return
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			http.Error(w, "invalid token claims", http.StatusUnauthorized)
			return
		}
		sub, ok := claims["sub"].(string)
		if !ok || sub == "" {
			http.Error(w, "invalid token subject", http.StatusUnauthorized)
			return
		}
		ctx := context.WithValue(r.Context(), ctxKeyUserID, sub)
		next(w, r.WithContext(ctx))
	}
}

// GetUserIDFromContext returns the user id stored by RequireAuth.
func GetUserIDFromContext(ctx context.Context) (string, bool) {
	v := ctx.Value(ctxKeyUserID)
	if v == nil {
		return "", false
	}
	id, ok := v.(string)
	return id, ok
}
