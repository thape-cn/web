# Public component browser checks

The category-link, empty-result and full contact-page checks can be run with the entire suite:

```sh
RAILS_ENV=test DATABASE_URL='sqlite3::memory:' \
  SHAKAPACKER_CONFIG=tmp/visual-quality/shakapacker.yml \
  VISUAL_PUBLIC_ROOT=tmp/visual-quality/public HEADED=1 \
  bundle exec ruby test/visual/listing_components_test.rb
```

These checks run all 17 category actions with fixed records, render all four real project-list templates and the complete contact template inside the application layout, and assert zero SQL. Empty results and paginated normal results remain distinct; reset links clear query parameters while retaining the category or city page. Contact headings are measured at 320, 390, 1340 and 1440px in Chinese/English, including actual Tt link clicks from small to large and back. No form is submitted. For only these new checks, append `--name '/test_(category_actions|listing_empty|biz_map_title)/'`.

These Minitest checks render the real application layout, navigation, news card, footer and office address partials with fixed samples. They do not load `test_helper`, fixtures, or application request callbacks. The city navigation query is stubbed, SEO fields are fixed values, and every test asserts that rendering issued zero SQL queries. The browser serves only the sample documents and compiled assets on a temporary local port; a response-header CSP blocks external dependencies, inline analytics and form submission without replacing the production layout.

From the repository root, build production assets into a separate directory without booting production Rails or replacing the running development server's packs:

```sh
mkdir -p tmp/visual-quality
python3 - <<'PY'
from pathlib import Path
config = Path('config/shakapacker.yml').read_text()
config = config.replace('public_root_path: public', 'public_root_path: tmp/visual-quality/public')
config = config.replace('cache_path: tmp/shakapacker', 'cache_path: tmp/visual-quality/cache')
config = config.replace('public_output_path: packs-test', 'public_output_path: packs')
config = config.replace('compile: true', 'compile: false')
Path('tmp/visual-quality/shakapacker.yml').write_text(config)
PY
RAILS_ENV=production NODE_ENV=production \
  SHAKAPACKER_CONFIG=tmp/visual-quality/shakapacker.yml \
  node node_modules/webpack/bin/webpack.js --config config/webpack/webpack.config.js
```

Run the checks against an empty, in-memory SQLite fallback. No schema preparation, migrations or seed data are needed:

```sh
RAILS_ENV=test DATABASE_URL='sqlite3::memory:' \
  SHAKAPACKER_CONFIG=tmp/visual-quality/shakapacker.yml \
  VISUAL_PUBLIC_ROOT=tmp/visual-quality/public \
  bundle exec ruby test/visual/public_components_test.rb
```

Chrome is required. Set `HEADED=1` for a visible desktop window and optionally `CHROMEDRIVER` to an installed compatible driver. The default is headless Chrome. Screenshots and measured viewport, contrast, line-wrap, icon-position and office-column evidence are written to `tmp/visual-quality/`. Test screenshots are explicitly labeled as fixed samples, not live content. Coverage includes Chinese/English navigation states, 390–1440px layouts, whole number/word wrapping, long-token fallback, QR hover/keyboard focus, all seven service links in native Tab order, ArrowDown entry, Escape dismissal/focus return (including while hovered), and responsive office gutters. Office overflow checks are scoped to the office section and its cards.

Run the mobile overlay checks and all the checks above together:

```sh
RAILS_ENV=test DATABASE_URL='sqlite3::memory:' \
  SHAKAPACKER_CONFIG=tmp/visual-quality/shakapacker.yml \
  VISUAL_PUBLIC_ROOT=tmp/visual-quality/public HEADED=1 \
  bundle exec ruby test/visual/mobile_overlays_test.rb
```

The suite refuses other database settings. Each test starts its own temporary Chrome profile and removes it on teardown. Before navigation, a browser request interceptor permits only GET/HEAD requests to the local fixture server; the suite asserts zero SQL and no other browser requests. Neither the Rails server on port 3000 nor the Shakapacker development server is used.

Mobile checks use 390×844 and 320×568 CSS pixel viewports, DPR 3, a mobile UA and touch gestures; desktop contact layout uses 1340px. The real contact, navigation, company address and cooperation form partials are rendered with fixed data. The document language comes only from `app/views/layouts/application.html.erb`; checks assert `cn` maps to `zh-CN`, English maps to `en`, mobile labels match the locale, and desktop labels remain bilingual. Coverage also includes internal menu/dialog scrolling, content/link clicks, backdrop/button/Escape dismissal, focus return, repeated opens, stacked locks, inline-style/scroll restoration, resize, controller disconnection, cache lifecycle events and document navigation. No form is submitted and no telephone, email or external link is activated. Simulated lifecycle events exercise cleanup without installing Turbo.

Run the introduction-menu, work-carousel and architecture-page checks together with the existing suite:

```sh
RAILS_ENV=test DATABASE_URL='sqlite3::memory:' \
  SHAKAPACKER_CONFIG=tmp/visual-quality/shakapacker.yml \
  VISUAL_PUBLIC_ROOT=tmp/visual-quality/public HEADED=1 \
  bundle exec ruby test/visual/experience_components_test.rb
```

These checks render the complete `works/show` and `services/building` templates through the real application layout. Work records and architecture prose are explicitly fixed test data. The work template's `wechat_config_js` helper is stubbed because signing can refresh remote tokens and write a ticket cache before the browser receives the page. No application request callback or database fixture runs. Coverage includes introduction links in Tab order, ArrowDown and Escape, real five-second automatic rotation, pause/resume, persistent focus pause, repeated manual controls, reduced-motion changes, touch, one-image galleries, disconnection, and Chinese/English architecture layouts at 320, 390, 1340 and 1440px with both `ts=sm` and `ts=big` cookie settings. Browser errors are recorded on failure.
