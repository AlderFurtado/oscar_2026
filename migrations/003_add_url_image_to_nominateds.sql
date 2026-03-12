-- Add url_image column to nominees so nominations can reference an image/poster URL
ALTER TABLE nominees ADD COLUMN IF NOT EXISTS url_image text;
