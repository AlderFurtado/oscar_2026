-- Add role column to users table (default: 'user')
ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) DEFAULT 'user';

-- Update existing users to have 'user' role if NULL
UPDATE users SET role = 'user' WHERE role IS NULL;
