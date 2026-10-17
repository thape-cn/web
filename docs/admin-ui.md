# Admin UI templates

All admin modules use the shared Rails views in `app/views/admin` and the
dedicated `admin` Shakapacker entrypoint. The layout and components are adapted
from `/Users/guochunzhong/git/application-ui-v4/html`:

| Admin view                                      | Tailwind Plus template                                                                              |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Desktop sidebar, mobile drawer, header          | `application-shells/sidebar/04-dark-sidebar-with-header.html`                                       |
| Dashboard quick links                           | `lists/grid-lists/04-horizontal-link-cards.html`                                                    |
| Dashboard module groups                         | `layout/cards/03-card-with-header.html`, `navigation/vertical-navigation/04-with-icons.html`        |
| Resource lists                                  | `lists/tables/03-simple-in-card.html`                                                               |
| Editors, SEO, project galleries, city roles     | `forms/form-layouts/04-two-column-with-cards.html`                                                  |
| Record details and messages                     | `data-display/description-lists/03-left-aligned-in-card.html`                                       |
| Login                                           | `forms/sign-in-forms/05-simple-card.html`                                                           |
| Shared page headings and breadcrumbs            | `headings/page-headings/03-with-actions-and-breadcrumbs.html`                                       |
| Dashboard totals                                | `data-display/stats/03-simple-in-cards.html`                                                        |
| Searchable module switcher                      | `navigation/command-palettes/08-with-groups.html`                                                   |
| Numbered list pagination                        | `navigation/pagination/01-card-footer-with-page-buttons.html`                                       |
| Picture library and nested gallery cards        | `lists/grid-lists/06-images-with-details.html`                                                      |
| Editor section links                            | `navigation/vertical-navigation/04-with-icons.html`                                                 |
| Dismissible flash messages and error summaries  | `feedback/alerts/06-with-dismiss-button.html`, `feedback/alerts/02-with-list.html`                  |
| Inline field errors                             | `forms/input-groups/03-input-with-validation-error.html`                                            |
| Native selects in editors, filters and ordering | `forms/select-menus/01-simple-native.html`                                                          |
| Deletion confirmation                           | `overlays/modal-dialogs/05-simple-with-gray-footer.html`                                            |
| Ordering dialog and arrow controls              | `overlays/modal-dialogs/04-simple-with-dismiss-button.html`, `elements/button-groups/01-basic.html` |
| Field help text                                 | `forms/input-groups/02-input-with-label-and-help-text.html`                                         |
| Empty lists and searches                        | `feedback/empty-states/01-simple.html`                                                              |
| Status and category filters                     | `navigation/tabs/01-tabs-with-underline.html`                                                       |
| Removable active filters                        | `elements/badges/07-with-border-remove-button.html`                                                 |
| Picture grid/list buttons                       | `elements/button-groups/01-basic.html`                                                              |
| Publication and visibility switches             | `forms/toggles/04-with-left-label-and-description.html`                                             |
| Project categories and team cities              | `forms/checkboxes/03-list-with-checkbox-on-right.html`                                              |
| File upload areas and local previews            | `forms/form-layouts/01-stacked.html` (cover photo field)                                            |
| Buttons and native upload buttons               | `elements/buttons/01-primary-buttons.html`, `elements/buttons/02-secondary-buttons.html`            |

Additional workflows use these references:

| Admin view                                     | Tailwind Plus template                                                |
| ---------------------------------------------- | --------------------------------------------------------------------- |
| Homepage project/news and picture news pickers | `forms/comboboxes/05-with-secondary-text.html`                        |
| Picture inspection drawer                      | `overlays/drawers/09-file-details-example.html`                       |
| Picture and message action menus               | `elements/dropdowns/04-with-minimal-menu-icon.html`                   |
| Message inbox previews                         | `lists/stacked-lists/14-narrow-with-truncated-content.html`           |
| Message inbox container                        | `layout/list-containers/02-card-with-dividers.html`                   |
| Message sender initials                        | `elements/avatars/08-circular-avatars-with-placeholder-initials.html` |
| Selected-message cleanup panel                 | `forms/action-panels/03-with-button-on-right.html`                    |

See [the complete component inventory](admin-components.md) for all 49 families.

The application uses Tailwind 1.9. Template utilities from v4 are translated to
supported utilities and reusable `@apply` components in
`app/packs/stylesheets/admin/application.scss`. Newer inset rings use inset
shadows, and column gaps use CSS. No CDN scripts or template runtime are needed.
The existing native dialogs and Rails UJS handle navigation, ordering and forms.
The admin stylesheet uses its own Tailwind configuration with the gray, indigo,
red and green colors and shadow sizes from the [v4 theme](https://github.com/tailwindlabs/tailwindcss/blob/v4.1.13/packages/tailwindcss/theme.css).
PostCSS selects this configuration only for the admin entrypoint; the public
stylesheet continues to use its existing theme. Focus outlines, status borders
and translucent backdrops use these same tokens.
Admin text sizes also use the v4 line heights: 16px for 12px text, 20px for 14px
text and 36px for dashboard values. Component-specific heading and field line
heights remain explicit.

Shared partials take explicit locals: headings accept titles, breadcrumbs and
action links; alerts accept a kind, message/list and dismissal state; pagination
accepts the paginated relation; empty states accept text, icon and an optional
action; media cards accept an image URL, title, optional subtitle and metadata with a block
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

The picture library accepts `view=grid|list` and defaults to grid. Desktop grids
use five columns and default to 25 images per page (five rows); smaller screens
use two or three columns. Search matches literal filenames or an exact picture ID
(with an optional `#`). Filters support file type, saved-content reference status
and reference module across all content languages. JPG includes JPEG, and file
types are case-insensitive. Reference filters use `picture_references`; the legacy
news association does not count as a saved-content reference. Filters combine
without duplicating images and persist through pagination and view changes.
Thumbnails link to the picture editor, dim on hover and show a focus outline when reached by
keyboard. Nested gallery previews remain separate from their form controls. Missing or
failed images show a placeholder. Gallery cards retain the existing nested
attributes, cached uploads, paired JPG/WebP fields and save-time deletion.
Editor section links are anchors; they do not hide fields or split the form.
They use unboxed navigation rows with 24px icons, 8px padding and a gray hover
background, matching the vertical-navigation template.
Inline errors also label the visible rich-text editor when a textarea is enhanced.
Field hints use the template's 14px help text and are linked to their inputs with
`aria-describedby`; validation messages are appended without replacing the hint.
Rich-text enhancement carries both hints and errors to the visible editor.

The header module search and Ctrl/Cmd+K open a native dialog containing the same
destinations as the sidebar. Search covers Chinese labels, resource keys and
descriptions locally. Arrow keys select links, Enter opens one, and Escape closes
the dialog and restores focus. Flash messages are manually dismissible, without
an automatic timeout. Deletion dialogs focus Cancel first and replay the original
Rails UJS action once after confirmation. If dialog enhancement is unavailable,
the original `data-confirm` native prompt remains active. No Tailwind Plus custom
elements, CDN scripts or additional JavaScript dependencies are loaded.
Tab navigation highlights the focused module link as well as arrow-key navigation.
An empty module search uses the reference's padded icon and message layout.
Clicking outside module, deletion and ordering panels closes the dialog and
restores focus to its opener; clicking within a panel keeps it open. Alerts use
the reference's filled circular icons, medium-weight headings and red list text.

Editor fields are grouped by `admin_form_sections` into basic information, text,
media and SEO. Every configured field is retained, including translation scopes,
upload caches, nested gallery inputs and rich text editor data attributes.
Section descriptions use one third of the editor row and form cards use two
thirds from 1280px; descriptions sit above the cards on smaller screens. Fields
have a 42rem maximum width, 24px column gaps and 32px row gaps. Short fields use
two columns from 640px, while textareas span both columns. Form cards have square
corners on phones and 12px corners from 640px. Chapter links wrap
above the form until 1600px, when they move into a sticky navigation column
without pushing descriptions above their cards.
SEO list editors use these same section cards, with descriptions outside each
card and a bordered save footer inside. Each record has its own form and field-ID
namespace, so labels focus that record's fields and saving submits only that
record. The filter and pagination bars sit separately from the editor cards.
The shared heading places breadcrumbs with 20px chevrons above the title/action
row, centers actions beside the title from 768px, and uses a parent back link on
phones. Header search shows its keyboard shortcut on desktop. The shell uses
40px vertical content padding and 16px/24px/32px responsive side padding.
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
Resource table cards and detail cards have square corners on phones and 8px
corners from 640px. Detail values span two columns of the reference's three-column
grid. Uploaded files use its bordered attachment rows with a paperclip icon,
truncated filename and a translated, accessible link that opens the file in a new
window; image files retain a preview above the row. Missing files show a dash.
Editor section headings align with card fields on phones. Switch labels and
descriptions use the reference's adjacent 24px/20px text lines.
Dashboard statistic labels and quick-link descriptions use single truncated lines,
with the full text retained in accessible content and hover titles. Picture cards
show the filename as the primary truncated title, with the record ID below it;
full filenames remain in hover titles and preview-link names. This keeps actions
aligned even for long filenames and distinguishes images with the same filename.
Mobile menu and drawer-close icons use the shell template's 24px size.
Dashboard module groups use the card template's 16px/24px responsive header and
body gutters. Their labeled navigation lists share the editor section links'
24px icons, 8px row padding, semibold text and indigo hover and keyboard-focus
states. Native upload buttons use the secondary button's 36px height, inset
border and hover background, with a visible system border in forced-color mode.

Picture usage links in the grid, list and picture editor come from
`picture_references`. Each reference belongs to a picture and a polymorphic
content owner, and records the field and language. A picture may be shared by
several records. Saving news, team profiles, works, about pages, service text or
SEO text refreshes their references transactionally; removing an image or deleting
its owner removes the corresponding references. Replacing a library file also
refreshes its existing owners. Matching uses the picture ID and current filename,
including URL-encoded filenames, rather than the filename alone.

The creation migration backfills existing saved content in all languages. Editor
uploads start unattached because the content record may not yet exist; saving the
content creates the relationships. Uploads that are never saved remain unattached.
The older optional `pictures.info_id` only represents a manually assigned news
association and is shown separately when no embedded reference exists for that
news item. It cannot represent shared pictures or non-news content. Usage links
open the owning editor in the appropriate language; a missing reference means
none was found in saved database content, rather than proof that a file is unused
outside the application.

The module palette has a single search row, gray group headings and an indigo
selected row. Its close button and descriptions remain available. Deletion
confirmation uses a 512px centered panel on desktop and a bottom-aligned panel
with a centered icon and stacked, full-width actions on phones. Cancel retains
initial focus. Validation errors keep red borders and focus styling, including
the rich-text editor. Flash messages use tinted backgrounds and matching dismiss
buttons; publication badges use a status-colored inset border. Active filter
badges use a compact gray inset border with a separate removal link and expanded
hit area. The module palette sits 16px/24px/80px below the viewport top, with
8px gaps between groups. Deletion dialogs use the template's gray backdrop
and a 24px warning icon.

The sidebar uses a 64px brand row, 24px navigation icons, 8px link padding and
28px gaps between groups. Its active and hover rows use the template's translucent
white background. The mobile drawer leaves at least 64px of backdrop visible and retains
an inside close button. Login uses a 480px card with 48px desktop padding; on
phones the card spans the viewport with 24px side padding and square corners.
Selects share the template chevron and reserve space for it in editors, list
filters and ordering dialogs. Checkboxes share rounded borders and explicit
checked, indeterminate and disabled styles. Both remain native form controls and
restore native appearance in forced-color mode. Invalid single-line inputs show
the template's error icon alongside their existing accessible error messages;
textareas and rich-text editors retain their full content width. Inputs use
36px minimum height, a 1px inset border and a 2px inset focus border; secondary buttons
and pagination use the same inset-border approach without adding layout width.
Rich-text focus styling follows the same indigo and red states. Forced-color
mode restores visible system borders where inset shadows would disappear.

Ordering uses the modal template's 512px borderless panel, gray backdrop and 24px
desktop padding, with a bottom-aligned panel and 16px side padding on phones.
Every ordered list shows a bordered, icon-only grip and an indigo instruction
panel when sorting JavaScript is available. Handles have a translated hover
tooltip, grab/grabbing cursors and an indigo hover state; the drop line marks the insertion point. Arrow and
Move controls remain available for keyboard use and moves across pages.
The close button receives focus first, and Escape or closing restores focus to
the originating move control. Arrow buttons use inset borders and shared edges;
the move control uses an SVG chevron. Without native dialog support, the same
ordering forms remain available inside the row's details element. The dialog
retains separate immediate actions for each ordering method. Dashboard totals
keep labels and values directly inside each description-list group, with a
stretched label link so the whole card remains clickable and keyboard accessible.

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

## Record pickers, picture inspection and messages

The homepage's six project IDs, three news IDs and hero-news ID, and the picture
editor's optional legacy news ID use searchable record pickers. Their existing
parameter names and stored IDs are unchanged. `GET /admin/record_options`
requires an admin session, allowlists `resource=works|infos`, accepts `q` and the
content locale, and returns at most 20 `{id, label, published}` options. Numeric
queries (with optional `#`) match an exact ID; other queries match literal title
substrings. Project titles use the chosen content language, and unpublished
projects remain available with their status visible. News has no publication
status, represented by `null`.

Selected records load with the form, including unresolved IDs, which remain
visible and are retained until changed. The enhanced input supports arrows,
Enter, Escape and clearing; unfinished search text blocks form submission until
selected or cleared. Empty results and failed requests appear below the field.
The original ID input remains usable without JavaScript. No new record validation
or public publication behavior is introduced.

Picture grid and list rows have a Details link to `GET /admin/pictures/:id`.
Ordinary navigation renders a full page; same-origin XHR requests render its
shared details fragment in a native right-side dialog. The inspector shows the
existing file, filename, ID, extension, timestamps and saved-content references,
including localized owner-editor links and separate legacy news associations.
Its action menu opens the original file, edits the picture or uses the existing
deletion confirmation. Failed image loads use a placeholder; failed detail
requests provide a full-page link. Escape, Close and backdrop dismissal restore
focus. Menus support arrows, Home/End and Escape without closing their parent
dialog. No file metadata is fetched from external services.

Both message modules default to `view=inbox`, with `view=table` available.
The view survives filtering, pagination and content-language changes. Inbox rows
show sender initials, company, timestamp, an escaped two-line message preview,
existing spam score (or Not scored), details and deletion. Full details and
Export all CSV retain their existing behavior. Selection never changes exports.

Individual message checkboxes work without JavaScript, with a required native
confirmation checkbox before deletion. Enhancement adds Select
this page, selected counts and a count-specific confirmation. Collection
`DELETE /admin/message/bulk_destroy` and
`DELETE /admin/project_messages/bulk_destroy` require authentication and CSRF,
accept `ids[]` and normalized list context, and validate 1–100 unique positive
IDs against the selected module and current page. Invalid or stale selections
delete nothing. Locked records are destroyed in one transaction; a failed
callback rolls back earlier deletions. Selection clears on navigation. There are
no new database tables, read states, automatic spam actions or dependencies.
