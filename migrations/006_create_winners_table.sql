CREATE TABLE IF NOT EXISTS winners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nominated_id UUID NOT NULL REFERENCES nominees(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(nominated_id)
);
