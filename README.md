# Yorick Funeral Notices

## ⚠️ **IMPORTANT: Development Workflow**
- **NEVER push directly to main branch** - This is strictly forbidden
- **ALL changes must go through Pull Requests**
- **PRs must pass both tests AND linting before merging**
- **No exceptions to this workflow**

See [DEVELOPMENT.md](DEVELOPMENT.md) for complete workflow details.

## App Technology Stack

- **Ruby**: 3.2.8
- **Rails**: 7.1.5.1
- **PostgreSQL**: 15 (via Docker)
- **Elasticsearch**: 8.13.4 (via Docker, Chewy gem for integration)
- **Pagy**: 9.3.4 (pagination)
- **Tailwind CSS**: 4.2 (via tailwindcss-rails)
- **Stimulus & Turbo**: for frontend interactivity
- **ViewComponent**: for reusable UI components
- **Foreman**: for process management in development

---

## How to Setup Dev Environment

1. **Clone the repository and install dependencies:**
   ```bash
   bundle install
   ```

2. **Start PostgreSQL and Elasticsearch with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

3. **Set up the database:**
   ```bash
   bin/rails db:setup
   ```

4. **Start the development server and assets watcher:**
   ```bash
   ./bin/dev
   ```
   This uses [Foreman](https://github.com/ddollar/foreman) to run both Rails and Tailwind CSS watcher (see `Procfile.dev`).

5. **Access the app:**
   - Rails server: [http://localhost:3000](http://localhost:3000)
   - Elasticsearch: [http://localhost:9200](http://localhost:9200)
   - PostgreSQL: [localhost:5432](localhost:5432) (user: `postgres`, password: `postgres`)

---

## How to Configure Production App

- **Database:**  
  Configure your production database in `config/database.yml` using environment variables for credentials.

- **Elasticsearch:**  
  Set the `CHEWY_HOST` and (optionally) `CHEWY_PREFIX` environment variables for Chewy in production.  
  See `config/chewy.yml`.

- **File Storage:**  
  By default, files are stored locally. For cloud storage, configure `config/storage.yml` and set up credentials.

- **Secrets:**  
  Ensure `RAILS_MASTER_KEY` or `config/credentials/production.key` is available for encrypted credentials.

- **SSL:**  
  SSL is enforced by default unless `DISABLE_SSL` is set.

- **Static Files:**  
  Set `RAILS_SERVE_STATIC_FILES` if you want Rails to serve static files (otherwise use a reverse proxy like NGINX).

---

## Rake Tasks

### 1. Run a Scrape or Recovery (with recovery_mode)

Scrape or recover funeral notices between a start_date and end_date (format: YYYY-MM-DD). Set recovery_mode=true to run in recovery mode.

Usage:
```bash
rake funeral_notices:scrape [start_date=YYYY-MM-DD end_date=YYYY-MM-DD recovery_mode=true|false]
```
- Example: `rake funeral_notices:scrape start_date=2024-01-01 end_date=2024-01-31`
- To recover missing funeral notices (e.g., due to errors or partial saves), set `recovery_mode=true`:
  ```bash
  recovery_mode=true rake funeral_notices:scrape start_date=2006-05-02 end_date=2024-01-31
  ```
- If no dates are provided, it will run from the very first date to today.
- In recovery mode, the task will only add notices whose text content is not already present for a given date, avoiding duplicates.

### 2. Run a Daily Scrape with Cron

The app uses the [whenever](https://github.com/javan/whenever) gem to schedule a daily scrape.  
See `config/schedule.rb` for the cron job definition:

- By default, it runs every day at 12:00 pm:
  ```
  every 1.day, at: '12:00 pm' do
    rake "funeral_notices:scrape"
  end
  ```
- To update your crontab:
  ```bash
  whenever --update-crontab
  ```

### 3. Reindex Entries (Elasticsearch)

If you need to reindex all entries (e.g., after changing the Chewy index):

```bash
bundle exec rake chewy:reset
```
- To reindex only the funeral notices index:
  ```bash
  bundle exec rake chewy:reset[funeral_notices]
  ```

## Environment Variables

Below are the key environment variables used for both development and production:

| Variable                | Description                                                                 | Example (Development)                                  | Example (Production)                        |
|-------------------------|-----------------------------------------------------------------------------|--------------------------------------------------------|---------------------------------------------|
| RAILS_ENV               | Rails environment (development or production)                                | development                                            | production                                  |
| RAILS_MASTER_KEY        | Master key for encrypted credentials (required in production)                | (leave blank or use dev key)                           | your_rails_master_key                       |
| DATABASE_URL            | Database connection string                                                  | postgres://postgres:postgres@localhost:5432/myapp_development | postgres://postgres:postgres@db:5432/myapp_production |
| ELASTICSEARCH_URL       | Elasticsearch endpoint                                                      | http://localhost:9200                                 | http://elasticsearch:9200                  |
| CHEWY_HOST (optional)   | Chewy/Elasticsearch host override                                           | (not set)                                             | elasticsearch:9200                         |
| CHEWY_PREFIX (optional) | Chewy index prefix (for namespacing in production)                          | (not set)                                             | yorick_production                          |
| RAILS_SERVE_STATIC_FILES| Set to true if Rails should serve static files (production, no reverse proxy)| (not set)                                             | true                                       |
| POSTGRES_USER           | Postgres username (used by db service)                                         | postgres                                                | postgres                                    |
| POSTGRES_PASSWORD       | Postgres password (used by db service)                                         | postgres                                                | postgres                                    |
| POSTGRES_DB             | Postgres database name (used by db service)                                    | myapp_development                                       | myapp_production                           |
| TZ                      | Timezone for database and services                                             | America/Argentina/Buenos_Aires                          | America/Argentina/Buenos_Aires              |
| ASSUME_SSL              | Set to 'true' to assume SSL is terminated by a proxy (default: false)           | false                                                  | true                                       |
| FORCE_SSL               | Set to 'true' to force SSL in Rails (default: true)                              | false                                                  | true                                       |

**Note:**
- For local development, you can set these in a `.env` file or export them in your shell.
- For Docker Compose production testing, use a `.env` file in the `.production-test` directory.
- Never commit real secrets (like `RAILS_MASTER_KEY`) to version control.
