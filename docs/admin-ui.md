# Admin UI templates

All admin modules use the shared Rails views in `app/views/admin` and the
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
| Shared page headings and breadcrumbs | `headings/page-headings/03-with-actions-and-breadcrumbs.html` |
| Dashboard totals | `data-display/stats/03-simple-in-cards.html` |
| Searchable module switcher | `navigation/command-palettes/08-with-groups.html` |
| Numbered list pagination | `navigation/pagination/01-card-footer-with-page-buttons.html` |
| Picture library and nested gallery cards | `lists/grid-lists/06-images-with-details.html` |
| Editor section links | `navigation/vertical-navigation/04-with-icons.html` |
| Dismissible flash messages and error summaries | `feedback/alerts/06-with-dismiss-button.html`, `feedback/alerts/02-with-list.html` |
| Inline field errors | `forms/input-groups/03-input-with-validation-error.html` |
| Deletion confirmation | `overlays/modal-dialogs/05-simple-with-gray-footer.html` |
| Empty lists and searches | `feedback/empty-states/01-simple.html` |
| Status and category filters | `navigation/tabs/01-tabs-with-underline.html` |
| Removable active filters | `elements/badges/07-with-border-remove-button.html` |
| Picture grid/list buttons | `elements/button-groups/01-basic.html` |
| Publication and visibility switches | `forms/toggles/04-with-left-label-and-description.html` |
| Project categories and team cities | `forms/checkboxes/03-list-with-checkbox-on-right.html` |
| File upload areas and local previews | `forms/form-layouts/01-stacked.html` (cover photo field) |

The application uses Tailwind 1.9. Template utilities from v4 are translated to
supported utilities and reusable `@apply` components in
`app/packs/stylesheets/admin/application.scss`. Newer inset rings use inset
shadows, and column gaps use CSS. No CDN scripts or template runtime are needed.
The existing native dialogs and Rails UJS handle navigation, ordering and forms.

Shared partials take explicit locals: headings accept titles, breadcrumbs and
action links; alerts accept a kind, message/list and dismissal state; pagination
accepts the paginated relation; empty states accept text, icon and an optional
action; media cards accept an image URL, title, filename and metadata with a block
for editor inputs or record actions. Resource-specific search/filter definitions
live in `Admin::Resource`, rather than in these shared components.

Dashboard counts are unscoped record totals across all content languages,
including unpublished works. Search uses `q` for all ordered modules and
honors the selected language for translated fields. Existing `project_name`,
`name` and `title` search aliases remain accepted. Works support `published`
(`true`/`false`), `city_id` and `project_type_id`; people support `category` and
`city_id`; news supports `category`; publications retain `category_status`.
Only supported values are carried into pagination and ordering links. Association
filters use subqueries to avoid duplicate records and inflated totals. Filter
submission and language changes reset the page. Clearing filters retains locale,
page size and picture view. Ordering remains global across pages and languages.

Works, news, people and publications expose their status or category filter as
ordinary navigation tabs. Tab changes and individual filter removal reset the
page while retaining the other filters, locale and page size. A hidden field
carries the selected tab through search submissions. Active filter chips show
the current search and filter labels, including when the result is empty. Selected
tabs and view buttons use explicit state classes so PurgeCSS retains their styles.

Boolean fields use labeled native checkboxes styled as switches, with descriptions
of their save-time effect. Association fields use checkbox lists with legends;
Rails' hidden empty-array input allows every selection to be cleared. These
controls, filter tabs and view buttons work without JavaScript. Forced-color mode
uses the native checkbox appearance for switches.

Upload fields share a component across regular editors and nested galleries.
Choosing a file shows its filename and a local preview for JPG, PNG, GIF and WebP;
other files show their filename. Cancelling a selection restores the current
file preview without clearing the upload cache or removal checkbox. No file is
uploaded until the form is saved. The native file input remains available without
JavaScript, and existing file guidance and server validation still apply.

The picture library accepts `view=grid|list` and defaults to grid. Missing or
failed images show a placeholder. Gallery cards retain the existing nested
attributes, cached uploads, paired JPG/WebP fields and save-time deletion.
Editor section links are anchors; they do not hide fields or split the form.
Inline errors also label the visible rich-text editor when a textarea is enhanced.

The header module search and Ctrl/Cmd+K open a native dialog containing the same
destinations as the sidebar. Search covers Chinese labels, resource keys and
descriptions locally. Arrow keys select links, Enter opens one, and Escape closes
the dialog and restores focus. Flash messages are manually dismissible, without
an automatic timeout. Deletion dialogs focus Cancel first and replay the original
Rails UJS action once after confirmation. If dialog enhancement is unavailable,
the original `data-confirm` native prompt remains active. No Tailwind Plus custom
elements, CDN scripts or additional JavaScript dependencies are loaded.

Editor fields are grouped by `admin_form_sections` into basic information, text,
media and SEO. Every configured field is retained, including translation scopes,
upload caches, nested gallery inputs and rich text editor data attributes.
Section descriptions use one third of the editor row and form cards use two
thirds from 1280px; descriptions sit above the cards on smaller screens. Fields
have a 42rem maximum width, 24px column gaps and 32px row gaps. Chapter links wrap
above the form until 1600px, when they move into a sticky navigation column
without pushing descriptions above their cards.
The shared heading places breadcrumbs above the title/action row, with a parent
back link on phones. Header search shows its keyboard shortcut on desktop.
Tables use compact interior cells and padded edges, and scroll within their cards
on phones. Pagination uses arrow buttons on desktop and labeled buttons on phones;
dashboard totals stack on phones and use two or four columns on larger screens.

The HTML references define the light-theme component appearance. The Rails
adaptations retain their spacing, typography, borders and responsive composition:
quick links use 40px circular icons and bordered horizontal cards; image-library
thumbnails use a 10:7 crop with details below the image; description lists use
16px mobile and 24px desktop edge padding. Nested gallery editors retain bordered
cards and uncropped previews so paired uploads remain visible. Form switches sit
beside their labels without an extra card, and checkbox lists use top, bottom and
row dividers. Upload areas use the cover-photo field's dashed border and padding,
with a native file input and local preview instead of an unsupported drop action.

The module palette has a single search row, gray group headings and an indigo
selected row. Its close button and descriptions remain available. Deletion
confirmation uses a 512px centered panel on desktop and a bottom-aligned panel
with a centered icon and stacked, full-width actions on phones. Cancel retains
initial focus. Validation errors keep red borders and focus styling, including
the rich-text editor. Flash messages use tinted backgrounds and matching dismiss
buttons; publication badges use a status-colored inset border.

Admin-specific differences remain deliberate: the header opens a module picker
instead of a global content search; language switching and record actions retain
their existing Rails routes; four dashboard totals use two/four-column layouts;
filter tabs remain scrollable links on phones; and a single sticky save bar submits
all editor sections and nested records together. Dark-mode template variants and
Tailwind Plus custom-element scripts are not loaded by this application.

After adding utilities, touch the admin stylesheet. With the dev server running,
let its watcher rebuild the assets and manifest together. Otherwise rebuild with
`RAILS_ENV=development bin/shakapacker`. Check the production build in a separate
output directory too, since PurgeCSS removes unused utilities there. Useful
regression checks are:

```sh
bin/rails test test/integration/admin/admin_test.rb
HEADLESS=1 PARALLEL_WORKERS=1 bin/rails test test/system/admin
```

The component system tests capture desktop and 390px mobile screenshots of the
dashboard, filtered list, editor, media grid, module search and deletion dialogs
under `tmp/screenshots/admin/components`. Build production assets with a separate
Shakapacker output/cache directory, then check both normal and interactive states
in that CSS so PurgeCSS does not remove dialog, focus, selection or error styles.
