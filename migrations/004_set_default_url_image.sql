-- Set default url_image for new rows and backfill existing NULL/empty values
ALTER TABLE nominees ALTER COLUMN url_image SET DEFAULT 'https://s2-gshow.glbimg.com/KIfsgPzVx8g-zWDxOSGy4llwWLw=/0x0:1080x1182/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_e84042ef78cb4708aeebdf1c68c6cbd6/internal_photos/bs/2026/y/S/gpOY25TAizQq9IcyUHeg/theacademy-20260102-150058-1663833045.jpg';

-- Backfill existing rows that are NULL or empty string
UPDATE nominees SET url_image = 'https://s2-gshow.glbimg.com/KIfsgPzVx8g-zWDxOSGy4llwWLw=/0x0:1080x1182/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_e84042ef78cb4708aeebdf1c68c6cbd6/internal_photos/bs/2026/y/S/gpOY25TAizQq9IcyUHeg/theacademy-20260102-150058-1663833045.jpg'
WHERE url_image IS NULL OR url_image = '';
