[![CircleCI](https://circleci.com/gh/thape-cn/web.svg?style=svg)](https://circleci.com/gh/thape-cn/web)

# README

## Introduce video (Chinese)

[![Watch the video](https://i.ytimg.com/vi/eJvLOpA4NtM/hqdefault.jpg)](https://www.youtube.com/watch?v=eJvLOpA4NtM&t=59s)

## Slide

[rubyconf2020-tailwind-css-rails6-alpinejs](https://www.thape.com/uploads/rubyconf2020-tailwind-css-rails6-alpinejs.key)

## Local development

### Requirements

- Ruby compatible with `Gemfile` and the Bundler version in `Gemfile.lock`. Ruby 3.4 is a known-working option for the current bundle.
- Node.js matching `package.json` (`^20.19.0 || >=22.12.0`) and the pnpm version declared by `packageManager`.
- A local PostgreSQL server, `psql`, and `pg_restore`. The schema works with PostgreSQL 12+, but use a maintained version and check compatibility with any supplied dump.
- Native build tools for gems. `bundle install` also fetches a Git-hosted dependency, so both the gem registry and that Git remote must be reachable.

### 1. Configure local databases before running setup

From the repository root:

```bash
cp -n config/database.yml.sample.yaml config/database.yml
bundle install
pnpm install --frozen-lockfile
```

Edit the ignored `config/database.yml` for your **local** PostgreSQL host, port and role. Keep development and test databases separate. The sample test host is `postgres` (useful in containers); change it or set `POSTGRES_HOST` for a standalone local server. Its other test overrides are `POSTGRES_DB`, `POSTGRES_USER` and `POSTGRES_PASSWORD`.

The application uses a PostgreSQL primary database and two separate SQLite archive databases. A PostgreSQL dump does not contain those SQLite databases or uploaded image files.

### 2. Choose empty-schema setup or a developer dump

For a new, disposable development database:

```bash
RAILS_ENV=development bin/rails db:prepare
```

For a developer dump, first verify its source/version and confirm the destination is an empty, local development database. Do not load a schema on top of restored data or blindly run `db:reset`. Examples below use placeholder filenames and the database configured above:

```bash
# Gzip-compressed plain SQL. Stop on errors; ignore local psql startup settings.
set -o pipefail
gzip -dc /path/to/development.sql.gz | psql -X -v ON_ERROR_STOP=1 -d thape_web_dev

# Alternatively, a PostgreSQL custom-format archive:
pg_restore --exit-on-error --no-owner --no-privileges \
  --dbname=thape_web_dev /path/to/development.dump

# Review pending changes before applying migrations to the local copy.
RAILS_ENV=development bin/rails db:migrate:status
```

Use a `pg_restore` version that understands the archive format; an older restore client may reject a newer dump. Prefer a sanitized developer export without ownership or grants. Treat dumps as executable database input: inspect unexpected functions, extensions or external commands before restoring.

An empty schema can boot Rails, but the homepage expects content such as a `TailHome` record and SEO data. The seeds do not provide a complete homepage. A missing content record is different from a failed server or database connection.

### 3. Keep development integrations explicit

Some development code paths use WeChat, object storage or AI services. Obtain only the development configuration needed for the task; do not reuse production credentials just to make a preview work. `WECHAT_CONF_FILE` can point to an owner-provided local WeChat configuration. For offline work, use local-only overrides for storage, jobs and external services, and keep them out of commits.

If encrypted Rails credentials are required, the owner must configure both `config/credentials.yml.enc` and its matching `config/master.key`. A key alone is insufficient. Do not print decrypted credentials, include them in logs, or commit either file.

A database restore does not restore media. Use authorized local media or explicitly approved public image reads. If the owner specifies a required `Referer` for image access, use that value rather than introducing object-storage credentials. Layouts also include external browser scripts, so a successful HTTP response is not proof that the browser made no external requests.

### 4. Build assets and run Rails

```bash
RAILS_ENV=development bin/shakapacker
bin/rails server --binding 127.0.0.1 --port 3000
```

For asset hot reload, run `bin/shakapacker-dev-server` in another terminal that shares the application's network environment. The current asset commands are `shakapacker`, not the older `webpack` binstubs.

In a sandbox or container, keep Rails and PostgreSQL in a mutually reachable network environment. A successful request inside that environment does not establish that a separate browser can reach its `localhost`. Use the environment's supported preview mechanism; do not expose the development server or database publicly as a workaround.

### 5. Verify the result

```bash
curl -I http://127.0.0.1:3000/
PARALLEL_WORKERS=1 bin/rails test test/models test/controllers test/integration/frontend_pages_test.rb
```

Confirm the test configuration points to a disposable local test database before running tests. `PARALLEL_WORKERS=1` is useful for a minimal local setup. Report application boot, database restore, asset compilation, HTTP checks and browser checks separately. Check desktop/mobile rendering, image loads and JavaScript behavior in a reachable browser; do not call HTTP-only checks visual validation.

# Develop notes

## Add a new Tailwind CSS

Due to Tailwind CSS 1.9 limit, must touch CSS after adding a new class(the class-name never used.)
