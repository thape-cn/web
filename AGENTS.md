# Repository Guidelines

## Project Structure & Module Organization

This Rails 7.2 application serves the public website, administration interface, and JSON APIs. Backend code lives in `app/models`, `app/controllers`, `app/services`, and `app/helpers`; ERB and Jbuilder templates live in `app/views`. Shakapacker bundles `app/packs/entrypoints`, with Stimulus controllers, SCSS, and images in adjacent directories. Static assets live in `public/`. Routes and translations are under `config/`; migrations and schemas are under `db/`. Tests and fixtures live in `test/`. Consult `docs/admin-ui.md` for admin changes.

## Build, Test, and Development Commands

Follow `README.md#local-development` for runtime requirements and database configuration. Use the pnpm version declared in `package.json` and preserve lockfiles.

- `bundle install` and `pnpm install --frozen-lockfile`: install dependencies.
- `RAILS_ENV=development bin/rails db:prepare`: prepare a configured, disposable local database.
- `RAILS_ENV=development bin/shakapacker`: compile development assets.
- `bin/rails server --binding 127.0.0.1 --port 3000`: start Rails locally.
- `bin/shakapacker-dev-server`: run the asset development server in another terminal.
- `PARALLEL_WORKERS=1 bin/rails test`: run Rails tests with one worker.
- `HEADLESS=1 bin/rails test:system`: run browser tests; Chrome is required.
- `pnpm check`: check Prettier and StandardRB formatting; `pnpm format` applies fixes.

## Coding Style & Naming Conventions

Use two-space indentation. Follow StandardRB for Ruby, retaining `# frozen_string_literal: true`; use English `snake_case` names and `CamelCase` classes. Prettier configures JavaScript with double quotes, no semicolons, trailing commas, and a 120-column width. ERB is outside these formatters' scope. Name Stimulus files `*_controller.js` and reusable ERB partials `_name.html.erb`. Keep business logic out of views and add translated text to `config/locales/cn.yml` and `en.yml`.

## Testing Guidelines

Use Minitest with `*_test.rb` files and descriptive `test "..."` cases; fixtures belong in `test/fixtures`. Add regression coverage for changed behavior. Browser tests use Capybara/Selenium. Run individual files with `bin/rails test test/models/city_test.rb`. Isolated visual checks require the setup in `test/visual/README.md`. No numeric coverage threshold is configured.

## Commit & Pull Request Guidelines

History favors plain, action-oriented subjects such as `Improve admin accessibility and ordering controls`; no consistent Conventional Commits prefix is used. Keep commits focused. Describe the problem, resulting behavior, and validation in pull requests. Link related issues, include screenshots for UI changes, and flag migration or configuration changes.

## Security & Configuration

Keep development and test databases separate. Never commit credentials, database dumps, uploads, or local overrides. Follow `docs/agent-local-setup.md` for integration and setup precautions.
