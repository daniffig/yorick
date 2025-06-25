# Yorick Funeral Notices

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
   yarn install # if you use JS dependencies
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

### 1. Run a First Scrape

Scrape funeral notices for a date range (defaults to all available dates):

```bash
rake funeral_notices:scrape start_date=YYYY-MM-DD end_date=YYYY-MM-DD
```
- Example: `rake funeral_notices:scrape start_date=2024-01-01 end_date=2024-01-31`

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
