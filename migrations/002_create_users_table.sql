-- idempotent migration to add users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    nickname TEXT NOT NULL,
    bio TEXT,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
