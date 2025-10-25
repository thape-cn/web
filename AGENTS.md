# Repository Guidelines

## Project Structure & Module Organization
This Rails 7 app keeps domain code in `app/` with controllers, models, and views alongside `app/packs` for Shakapacker entrypoints and Stimulus/Tailwind assets. Shared helpers and background jobs sit under `app/helpers` and `app/jobs`. `lib/` holds PORO extensions; prefer namespaced modules when adding cross-cutting utilities. Configuration lives in `config/`, while feature specs and fixtures belong in `test/`. Static files and compiled uploads land in `public/` and `storage/`. Use `db/migrate` for schema changes and seed data through `db/seeds.rb`.

## Build, Test, and Development Commands
Run `bin/setup` after cloning to install gems, pnpm install packages, and prepare the database. Start the Rails server with `bin/rails s` and the asset compiler with `bin/shakapacker-dev-server` when iterating on front-end packs. Use `bin/rails db:prepare` whenever migrations change. For production-like asset builds invoke `RAILS_ENV=production bin/shakapacker`.

## Coding Style & Naming Conventions
Ruby code follows the `standard` formatter (two-space indent, single quotes, no trailing semicolons); run `bundle exec standardrb --fix` before committing. Name directories and files using snake_case, and keep classes/modules singular and namespaced by feature (e.g. `Admin::InvoicesController`). JavaScript packs should export camelCase helpers and Stimulus controllers in PascalCase. Tailwind utility additions require touching the relevant stylesheet so PurgeCSS retains the new class.

## Testing Guidelines
Tests use Rails’ Minitest stack. Place unit and integration tests under `test/models` and `test/controllers`; system tests live in `test/system`. Name files after the class under test (`user_test.rb`) and use fixtures from `test/fixtures`. Run the suite with `bin/rails test`; target failing namespaces with `bin/rails test test/models/user_test.rb`. System tests rely on Selenium; ensure ChromeDriver is available locally.

## Commit & Pull Request Guidelines
Commit messages are short, imperative summaries (see history: "gem upgrade", "Enable rorvswild"). Group related changes per commit and include migration notes in the body if schema shifts. Pull requests should describe the motivation, the main changes, and any follow-up work. Link planning tickets when available and attach before/after screenshots for UI-facing updates. Mention required environment variables or data seeds when reviewers need them.

## Deployment & Configuration Tips
Capistrano scripts in `config/deploy` drive deployments; update stage-specific settings there. Manage credentials through `config/credentials.yml.enc` and avoid committing plaintext secrets. Database defaults target PostgreSQL—recreate the dev database via the scripts in `README.md` when syncing production data.
