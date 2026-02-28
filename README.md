# votacao - simple Go service to add movies
# votacao - simple Go service to add movies

This repository provides a tiny Go HTTP service with an endpoint POST /add_movie that stores movie records into PostgreSQL.

Environment variables (defaults shown):

- PG_HOST=localhost
- PG_PORT=5432
- PG_USER=postgres
- PG_PASSWORD=postgres
- PG_DB=moviesdb
- HTTP_ADDR=:8080

Request example:

POST /add_movie
Content-Type: application/json

{
  "title": "Inception"
}

Response: 201 Created with JSON containing the inserted movie including its `id`.

Notes:
- The service will create the `movies` table automatically if it does not exist.
- To run: set your environment variables and then `go run .`

Examples (curl)

Single movie:

```bash
curl -X POST http://localhost:8080/add_movie \
  -H "Content-Type: application/json" \
  -d '{"title":"Inception"}'
```

Multiple movies (bulk):

```bash
curl -X POST http://localhost:8080/add_movies \
  -H "Content-Type: application/json" \
  -d '[{"title":"Inception"},{"title":"The Matrix"}]'
```

API endpoints

- POST /add_movie  — add a single movie (JSON object)
- POST /add_movies — add multiple movies at once (JSON array of objects)
- GET  /movies      — list movies (optional query param `id` to get a single movie)

Database migration

If you already have an existing `movies` table with extra columns (e.g. `director`,
`year`, `rating`) and want to enforce the simplified schema (only `id` and
`title`) you can run the migration script included in `migrations/001_simplify_movies_schema.sql`.

Warning: the migration will DROP the old `movies` table after copying `id` and
`title` into the new table. Back up your database if you need to preserve the
additional columns or other data before running this script.

Run the migration with psql (example using environment vars):

```bash
PGHOST=${PG_HOST:-localhost} PGPORT=${PG_PORT:-5432} PGUSER=${PG_USER:-postgres} PGPASSWORD=${PG_PASSWORD:-postgres} PGDATABASE=${PG_DB:-moviesdb} \
  psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f migrations/001_simplify_movies_schema.sql
```

If the migration reports "Migration not required" then your table already
matches the simplified schema and no action was taken.
