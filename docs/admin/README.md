# Admin maintenance

Open `/admin` (or `/admin/login`) and sign in with an existing old_web administrator email and password. This port reads the existing `users` table and BCrypt password digests. Deploy against the same primary content database previously maintained by old_web; no content import, database migration, or password reset is included.

All 20 legacy sections are available: old homepage/about, people, classic cases, news, SEO, branch contacts, administrators, current works/homepage/about/work category pages, professional services, cities, image hosting, guest messages, project enquiries, portfolios, publications, and internal journals. Existing route names, including the legacy `destory_picture` and `destory_city_people` spellings, are retained.

Content uses ordinary textareas, including existing HTML. WYSIWYG editing and its upload endpoint are deferred. All position-sorting controls and endpoints are deferred, including works, people, cases, news, and publication ordering. Existing positions are preserved on edits.

The language switch selects Chinese or English content through Globalize. It uses an admin session preference independently of the public site's locale cookie. Works include unpublished records; their public model's published-only scope is unchanged. Work category selections, city memberships and city-specific roles, paired JPG/WebP project galleries, legacy case galleries, covers, PDFs, and other uploads are supported. Gallery forms provide three additional upload rows on each save. Uploaded files keep their original public storage paths.

The two message sections support viewing, deletion and UTF-8 CSV export of all records. Exports neutralize spreadsheet formulas in submitted values. Every maintenance endpoint requires an authenticated admin; nested writes are scoped to their parent and saved in a transaction. Administrators cannot delete their own active account.

Implementation is contained in admin controllers, models, helpers, views, configuration and assets. Shared wiring consists only of `draw :admin` in `config/routes.rb` and the BCrypt dependency in `Gemfile`/`Gemfile.lock`. Customer controllers, models, views, stylesheets, scripts and database schema are unchanged.

The admin UI uses a grouped sidebar, dashboard shortcuts, responsive tables, publication badges, and consistent form, upload, and detail panels. On smaller screens, the menu opens as a keyboard-accessible dialog; wide tables scroll within their own panel. The content-language selector stays visible in the header. The UI labels remain Chinese when editing English content.

Visual patterns were adapted from the licensed Tailwind Plus `application-ui-v4/html` reference: `application-shells/sidebar/06-with-off-white-background.html`, `lists/tables/01-simple.html`, `forms/form-layouts/04-two-column-with-cards.html`, `forms/sign-in-forms/05-simple-card.html`, and `data-display/description-lists/03-left-aligned-in-card.html`. They use this app's existing Tailwind CSS 1.9 utilities and admin-only components in `app/packs/stylesheets/admin/application.scss`; no Tailwind upgrade or external component runtime is required. Touch that stylesheet when adding template utilities so production PurgeCSS runs again.

For a new database with no administrators, an operator can create the first account through `Admin::User` in the Rails console, supplying their own email and password. There is no default account or public registration endpoint.

Validation commands:

```sh
PARALLEL_WORKERS=1 bin/rails test test/integration/admin/admin_test.rb test/controllers test/models test/channels
HEADLESS=1 PARALLEL_WORKERS=1 bin/rails test test/system/admin/maintenance_test.rb
RAILS_ENV=production bin/shakapacker
bundle exec standardrb app/controllers/admin app/models/admin app/helpers/admin test/integration/admin test/system/admin config/routes/admin.rb
```

Run database tests sequentially. The admin integration tests restore missing PostgreSQL identity metadata transactionally in the test database because the checked-in schema snapshot omits it; this does not change the schema file or development/production databases. Browser tests save desktop and mobile screenshots under `tmp/screenshots/admin/`.
