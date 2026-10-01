# Public component browser checks

These Minitest checks render the real navigation, news card and footer partials with fixed samples. They do not load `test_helper`, fixtures, or application request callbacks. The city navigation query is stubbed and every test asserts that rendering issued zero SQL queries. The browser serves only the sample documents and compiled assets on a temporary local port; CSP blocks external dependencies and form submission.

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

Chrome is required. Set `HEADED=1` for a visible desktop window and optionally `CHROMEDRIVER` to an installed compatible driver. The default is headless Chrome. Screenshots and measured viewport, contrast, line-wrap and icon-position evidence are written to `tmp/visual-quality/`. Test screenshots are explicitly labeled as fixed samples, not live content. Coverage includes Chinese/English navigation states, 390–1440px layouts, whole number/word wrapping, long-token fallback, and QR hover/keyboard focus.
