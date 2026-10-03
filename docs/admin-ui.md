# Admin UI templates

All 18 admin modules use the shared Rails views in `app/views/admin` and the
dedicated `admin` Shakapacker entrypoint. The layout and components are adapted
from `/Users/guochunzhong/git/application-ui-v4/html`:

| Admin view | Tailwind Plus template |
| --- | --- |
| Desktop sidebar, mobile drawer, header | `application-shells/sidebar/04-dark-sidebar-with-header.html` |
| Dashboard links and module cards | `lists/grid-lists/04-horizontal-link-cards.html` |
| Resource lists | `lists/tables/03-simple-in-card.html` |
| Editors, SEO, project galleries, city roles | `forms/form-layouts/04-two-column-with-cards.html` |
| Record details and messages | `data-display/description-lists/03-left-aligned-in-card.html` |
| Login | `forms/sign-in-forms/05-simple-card.html` |

The application uses Tailwind 1.9. Template utilities from v4 are translated to
supported utilities and reusable `@apply` components in
`app/packs/stylesheets/admin/application.scss`. Newer inset rings use inset
shadows, and column gaps use CSS. No CDN scripts or template runtime are needed.
The existing native dialogs and Rails UJS handle navigation, ordering and forms.

Editor fields are grouped by `admin_form_sections` into basic information, text,
media and SEO. Every configured field is retained, including translation scopes,
upload caches, nested gallery inputs and rich text editor data attributes.
The section descriptions sit alongside form cards on wide desktops and above
them on smaller screens. Tables scroll within their cards on phones.

After adding utilities, touch the admin stylesheet. With the dev server running,
let its watcher rebuild the assets and manifest together. Otherwise rebuild with
`RAILS_ENV=development bin/shakapacker`. Check the production build in a separate
output directory too, since PurgeCSS removes unused utilities there. Useful
regression checks are:

```sh
bin/rails test test/integration/admin/admin_test.rb
HEADLESS=1 PARALLEL_WORKERS=1 bin/rails test:system test/system/admin
```
