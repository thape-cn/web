# CODEBUDDY.md This file provides guidance to CodeBuddy Code when working with code in this repository.

## Project Overview

This is a Rails 7.2.2 application (Ruby 3.0+) with Shakapacker (Webpacker), Stimulus, and Tailwind CSS 1.9.6. It's a bilingual (Chinese/English) architectural firm website with PostgreSQL/SQLite databases. The application uses pnpm for JavaScript package management and Capistrano for deployment.

## High-Level Architecture

### Core Structure
- **Rails MVC**: Standard structure in `app/` with controllers, models, and views
- **Webpacker bundling**: `app/packs/` contains Stimulus controllers, stylesheets, and entry points
- **Dual locales**: Chinese (cn, default) and English (en) with `/cn/` and `/en/` redirect paths
- **API layer**: JSON responses via Jbuilder in `app/views/api/` for `app/controllers/api/**`
- **SEO**: `full_title` helper in `app/helpers/application_helper.rb`; SEO metadata set in `ApplicationController`
- **Background jobs**: `app/jobs/`
- **File uploads**: CarrierWave with Aliyun storage (`app/uploaders/`)

### Frontend Architecture (app/packs/)
- **Entrypoints**: `app/packs/entrypoints/application.js` and `tianhua_2020.js`
- **Stimulus controllers**: Auto-registered from `app/packs/controllers/*_controller.js` via index.js
- **Styles**: SCSS in `app/packs/stylesheets/` or imported by entrypoints
- **Images**: `app/packs/images/`

### Database Strategy
- **Production**: PostgreSQL
- **Development**: Multi-database setup (PostgreSQL primary + SQLite databases for tianhua2019/tianhua2020)
- **Locale**: I18n YAMLs in `config/locales/cn.yml` and `en.yml`

## Common Development Commands

### Initial Setup
```bash
bin/setup  # Install gems, pnpm packages, prepare DB, clear logs
bundle install && pnpm install && bin/rails db:prepare
```

### Development Server
```bash
bin/rails s  # Rails server (use separate terminal)
bin/shakapacker-dev-server  # Asset compilation with hot reload
# OR for production-like builds:
RAILS_ENV=production bin/shakapacker
```

### Database Management
```bash
bin/rails db:prepare  # Prepare database after migrations
# Import production data (from README.md):
psql -d postgres
DROP DATABASE thape_web_dev;
CREATE DATABASE thape_web_dev WITH ENCODING='UTF8';
\q
gunzip < thape_web_prod.sql.gz | psql -d thape_web_dev
```

### Testing
```bash
bin/rails test  # Run full test suite
bin/rails test test/models/user_test.rb  # Run specific test file
bin/rails test:system test  # Run system tests (Capybara + Selenium)
```

### Code Quality
```bash
bundle exec standardrb --fix  # Auto-fix Ruby style issues before committing
```

### Deployment
```bash
cap production deploy  # Deploy to production via Capistrano
cap staging deploy     # Deploy to staging
```

## Testing Strategy

The project uses Rails Minitest with:
- **Unit/Integration tests**: `test/models/`, `test/controllers/`
- **System tests**: `test/system/` using Capybara + Selenium (ChromeDriver required)
- **Fixtures**: `test/fixtures/`
- **CI**: Both CircleCI (`.circleci/config.yml`) and GitLab CI (`.gitlab-ci.yml`)
  - Tests run with PostgreSQL database in CI
  - Assets compiled before tests in CI pipeline

## Key Conventions

### Ruby/Rails
- **Frozen string literal**: `# frozen_string_literal: true` at top of all `.rb` files
- **Styling**: `standard` formatter (2-space indent, single quotes, no trailing semicolons)
- **Controller patterns**:
  - Set locale, SEO, and browser warnings in `ApplicationController`
  - Use strong parameters and `only:` filters in routes
  - Avoid logic in views; use instance variables
- **Naming**: snake_case for files/directories; singular class names (e.g., `works`, `leadership`, `publications`)
- **Security**: `csrf_meta_tags` in layouts; permit only necessary params

### JavaScript/CSS
- **Entrypoints**: Create new files under `app/packs/entrypoints` for page-specific bundles
- **Stimulus**: Name controllers with `_controller.js` suffix for auto-registration
- **Imports**: Resolve relative to `app/packs`
- **Tailwind CSS**: Due to Tailwind 1.9 PurgeCSS limitation, **touch the CSS file after adding new classes** to ensure they're included in the build
- **IE support**: Special controllers (`home_ie11_controller.js`, `scroll_ie11_controller.js`)

### I18n
- **Default locale**: Chinese (cn)
- **Available locales**: en, cn
- **Translation files**: `config/locales/cn.yml`, `config/locales/en.yml`
- **Old URL redirects**: `/cn/*` and `/en/*` paths redirect to root or add `?locale=en`

## Special Configuration Details

### Multi-Database Setup
- Primary PostgreSQL database for main application data
- SQLite databases for tianhua2019 and tianhua2020 with separate migration paths
- Use `db:prepare` to handle all databases

### External Dependencies
- **WeChat gem**: `wechat` from internal Git server (configured via `bundle config local.wechat`)
- **LLM gem**: `dify_llm` (configured via `bundle config local.dify_llm`)
- **Aliyun**: File storage via `carrierwave-aliyun`
- **JavaScript**: pnpm package manager with frozen lockfile

### Asset Pipeline
- Shakapacker 8.2 with Webpack 5
- Stimulus 2.0 for JavaScript interactivity
- Tailwind CSS 1.9.6 with PurgeCSS optimization
- PostCSS with custom configuration

## Development Workflow

### Before Committing
1. Run `bundle exec standardrb --fix` to fix Ruby style issues
2. Ensure tests pass: `bin/rails test`
3. If adding Tailwind classes, touch the relevant stylesheet file
4. Check that assets compile without errors

### Adding New Features
1. Create routes in `config/routes.rb`
2. Add controller in appropriate namespace (`app/controllers/`)
3. Create views in `app/views/`
4. Add translations to both `config/locales/cn.yml` and `config/locales/en.yml`
5. Add tests in appropriate `test/` subdirectory

### Frontend Development
1. For new page-specific JavaScript, create entrypoint in `app/packs/entrypoints/`
2. For reusable interactions, create Stimulus controllers in `app/packs/controllers/`
3. Use Tailwind utility classes; remember to touch CSS files after adding new classes

## Deployment Architecture

Capistrano-based deployment with:
- **Ruby version**: 3.4.4 (set in `config/deploy.rb`)
- **Web server**: Puma with phased restarts
- **JavaScript**: pnpm with `--silent` flag
- **Linked files**: `config/database.yml`, `config/master.key`, `config/credentials.yml.enc`, `puma.rb`
- **Linked dirs**: `public/uploads`, `public/packs`, `log/`, `tmp/`, etc.
- **Strategy**: Automatic Rails migration running during deployment

## Critical Development Notes

1. **Tailwind CSS Limitation**: After adding new Tailwind utility classes, touch the relevant stylesheet file so PurgeCSS includes the new classes in production builds
2. **Multi-Database**: Be aware of which database you're querying (primary vs tianhua2019/tianhua2020 SQLite databases)
3. **Browser Support**: Application includes IE11 support via special controllers and polyfills
4. **Credentials**: Production credentials managed via encrypted file and `master.key` - never commit secrets
5. **File Uploads**: Images and files stored in Aliyun OSS in production, local storage in development
6. **SEO**: Use `full_title` helper and set `@seo` instance variable for meta tags in controllers
7. **Locale Management**: Always add translations to both language files; Chinese is default