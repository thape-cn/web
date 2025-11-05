# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
- **Development**: Can use either PostgreSQL or SQLite
- **Locale**: I18n YAMLs in `config/locales/cn.yml` and `en.yml`

## Common Development Commands

### Initial Setup
```bash
bundle install
pnpm install
RAILS_ENV=production bin/webpack  # Build assets for production
bin/webpack-dev-server  # In separate terminal
bin/rails s  # Run server
```

### Database Management
```bash
bin/rails db:prepare  # Prepare database after migrations
# Import production data (from README.md):
psql -d postgres
DROP DATABASE thape_web_dev;
CREATE DATABASE thape_web_dev WITH ENCODING='UTF8';
gunzip < thape_web_prod.sql.gz | psql -d thape_web_dev
```

### Testing
```bash
bin/rails test  # Run full test suite
bin/rails test test/models/user_test.rb  # Run specific test
bin/rails test:system test  # Run system tests (Capybara + Selenium)
```

### Code Quality
```bash
bundle exec standardrb --fix  # Auto-fix Ruby style issues
```

### Asset Compilation
```bash
RAILS_ENV=production bin/shakapacker  # Production-like build
bin/shakapacker-dev-server  # Development server with hot reload
```

### Deployment (Capistrano)
```bash
cap production deploy  # Deploy to production
```

## Testing Strategy

The project uses Rails Minitest with:
- **Unit/Integration tests**: `test/models/`, `test/controllers/`
- **System tests**: `test/system/` using Capybara + Selenium
- **Fixtures**: `test/fixtures/`
- **CI**: Both CircleCI (`.circleci/config.yml`) and GitLab CI (`.gitlab-ci.yml`)
  - Tests run with PostgreSQL database
  - Assets compiled before tests

## Deployment

Capistrano-based deployment with:
- **Ruby version**: 3.4.4 (set in `config/deploy.rb`)
- **Web server**: Puma
- **JavaScript**: pnpm with `--silent` flag
- **Linked files**: `config/database.yml`, `config/master.key`, `config/credentials.yml.enc`, `puma.rb`
- **Linked dirs**: `public/uploads`, `public/packs`, `log/`, `tmp/`, etc.
- **Strategy**: Phased Puma restart, automatic Rails migration running

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

## Important Configuration Files

- **Routes**: `config/routes.rb` - Contains extensive `/cn/` and `/en/` redirect rules
- **Database**: `config/database.yml`
- **Credentials**: `config/credentials.yml.enc` (managed via `master.key`)
- **Webpacker**: `config/shakapacker.yml`
- **Deployment**: `config/deploy.rb`
- **Locales**: `config/locales/cn.yml`, `config/locales/en.yml`
- **Tailwind**: `postcss.config.js`
- **Schedule**: `config/schedule.rb` (whenever gem for cron jobs)
- **Sitemap**: `config/sitemap.rb`

## External Dependencies

- **WeChat gem**: `wechat` from internal Git server (configured via `bundle config local.wechat`)
- **LLM gem**: `dify_llm` (configured via `bundle config local.dify_llm`)
- **Aliyun**: File storage via `carrierwave-aliyun`
- **WeChat**: Configuration in `config/wechat.yml`

## CI/CD

### CircleCI
- Ruby 3.4.3 with browsers image
- PostgreSQL service container
- Bundle and pnpm caches
- Runs `bin/rails test:system test`
- Stores test results and coverage

### GitLab CI
- Similar setup with stages: test, deploy
- Installs pnpm via corepack or npm
- Uses vendor/bundle for Ruby gems

## Development Notes

1. **Tailwind CSS Limitation**: After adding new Tailwind utility classes, touch the relevant stylesheet file so PurgeCSS includes the new classes
2. **Browser Support**: Includes IE11 support via special controllers
3. **Credentials**: Production credentials managed via encrypted file and `master.key`
4. **File Uploads**: Images and files stored in Aliyun OSS in production
5. **SEO**: Use `full_title` helper and `@seo` instance variable for meta tags
