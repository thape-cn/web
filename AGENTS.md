# Repository Guidelines

## Project Structure & Module Organization
- `app/`: Rails MVC (controllers, models, views, helpers, jobs, uploaders).
- `app/packs/`: Shakapacker assets (entrypoints, Stimulus controllers, stylesheets, images).
- `config/`: routes, locales (`config/locales/*.yml`), environment settings.
- `db/`: migrations and multi-database setup (PostgreSQL primary plus SQLite archives).
- `test/`: Minitest suites and fixtures.
- `public/`: static assets, compiled packs, and uploads.

## Build, Test, and Development Commands
- `bin/setup`: install gems + pnpm deps, prepare DBs, clear logs, restart app.
- `bin/rails s`: start Rails server.
- `bin/shakapacker-dev-server`: run webpack dev server for hot reload.
- `RAILS_ENV=production bin/shakapacker`: production-like asset build.
- `bin/rails db:prepare`: create/update all databases after migrations.
- `bin/rails test`: run full test suite.
- `bin/rails test test/models/example_test.rb`: run a single test file.
- `bin/rails test:system test`: system tests (Capybara + Selenium/ChromeDriver).
- `bundle exec standardrb --fix`: auto-fix Ruby style issues.

## Coding Style & Naming Conventions
- Ruby: 2-space indentation, `standardrb` formatting, `# frozen_string_literal: true` on `.rb` files.
- Naming: snake_case files and directories; classes are singular.
- Frontend: entrypoints live in `app/packs/entrypoints/`; Stimulus controllers must end with `_controller.js`.
- Tailwind CSS 1.9: after adding new utility classes, touch the relevant stylesheet so PurgeCSS picks them up.

## Testing Guidelines
- Framework: Rails Minitest under `test/` with `_test.rb` naming.
- System tests live in `test/system/` and require a browser driver.
- Prefer adding tests alongside feature work; run the narrowest test scope before full suite.

## Commit & Pull Request Guidelines
- Commits are short and direct (e.g., `pnpm upgrade`, `Enable rorvswild`). Keep messages concise and action-oriented.
- PRs should include: a brief summary, test evidence, and screenshots for UI changes. Note any migrations, config updates, or data imports.

## Security & Configuration Tips
- Do not commit secrets. Credentials are stored in `config/credentials.yml.enc` and unlocked via `config/master.key`.
- Production uses PostgreSQL; development also includes SQLite databases for archived content. Use `bin/rails db:prepare` to keep them in sync.
