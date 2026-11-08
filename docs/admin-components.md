# Admin component inventory

The local `application-ui-v4/html` library contains 49 families and 364 HTML
templates. The admin has explicit source mappings for 34 families (42 variants),
including native textareas verified in the remaining component audit; 6 more
have embedded or custom patterns, and 9 remain unused.

**Adapted** identifies a documented library reference. **Pattern** means related
markup exists within another adaptation or custom component, without a separate
template adoption. Unused families are listed without proposed features.

See [Admin UI templates](admin-ui.md) for exact template filenames, behavior and
validation. Shared render locations are `app/views/admin/resources`,
`app/views/admin/shared`, `app/views/admin/pictures` and the admin layout; styling
and interactions live under the admin pack.

| Component family                  | Variants | Status and current location                                 |
| --------------------------------- | -------: | ----------------------------------------------------------- |
| `application-shells/multi-column` |        6 | Unused                                                      |
| `application-shells/sidebar`      |        8 | Adapted — Shared desktop/mobile shell and header            |
| `application-shells/stacked`      |        9 | Unused                                                      |
| `data-display/calendars`          |        8 | Unused                                                      |
| `data-display/description-lists`  |        6 | Adapted — Resource and message details                      |
| `data-display/stats`              |        5 | Adapted — Dashboard totals                                  |
| `elements/avatars`                |       11 | Adapted — Message sender initials                           |
| `elements/badges`                 |       16 | Adapted — Status indicators and removable active filters    |
| `elements/button-groups`          |        5 | Adapted — Ordering arrows and picture/message view switches |
| `elements/buttons`                |        8 | Adapted — Primary, secondary and upload actions             |
| `elements/dropdowns`              |        5 | Adapted — Picture and message action menus                  |
| `feedback/alerts`                 |        6 | Adapted — Flash messages, validation and loading failures   |
| `feedback/empty-states`           |        6 | Adapted — Empty lists and searches                          |
| `forms/action-panels`             |        8 | Adapted — Selected-message cleanup                          |
| `forms/checkboxes`                |        4 | Adapted — Associations and message selection                |
| `forms/comboboxes`                |        4 | Adapted — Homepage and picture news record pickers          |
| `forms/form-layouts`              |        4 | Adapted — Editors, SEO, galleries and upload areas          |
| `forms/input-groups`              |       21 | Adapted — Labels, hints and inline errors                   |
| `forms/radio-groups`              |       12 | Adapted — People, news and publication category editors     |
| `forms/select-menus`              |        7 | Adapted — Editors, filters, ordering and page size          |
| `forms/sign-in-forms`             |        4 | Adapted — Administrator login                               |
| `forms/textareas`                 |        5 | Adapted — Native textareas; rich-text enhancement retained  |
| `forms/toggles`                   |        5 | Adapted — Publication and visibility fields                 |
| `headings/card-headings`          |        6 | Adapted — Dashboard module cards and record detail headers  |
| `headings/page-headings`          |        9 | Adapted — Page titles, actions and breadcrumbs              |
| `headings/section-headings`       |       10 | Adapted — Carousel count, guidance and Add slide control    |
| `layout/cards`                    |       10 | Adapted — Dashboard groups and shared panels                |
| `layout/containers`               |        5 | Pattern — Responsive shell content width and gutters        |
| `layout/dividers`                 |        8 | Pattern — Borders within existing lists, cards and forms    |
| `layout/list-containers`          |        7 | Adapted — Message inbox container                           |
| `layout/media-objects`            |        8 | Pattern — Account block and icon/text shortcuts             |
| `lists/feeds`                     |        3 | Unused                                                      |
| `lists/grid-lists`                |        7 | Adapted — Dashboard shortcuts, picture grids and galleries  |
| `lists/stacked-lists`             |       15 | Adapted — Message inbox previews                            |
| `lists/tables`                    |       19 | Adapted — Resource lists, mobile metadata and message table |
| `navigation/breadcrumbs`          |        4 | Pattern — Embedded in the page-heading reference            |
| `navigation/command-palettes`     |        8 | Adapted — Module switcher                                   |
| `navigation/navbars`              |       11 | Pattern — Embedded in the sidebar-shell reference           |
| `navigation/pagination`           |        3 | Adapted — Numbered resource pagination                      |
| `navigation/progress-bars`        |        8 | Unused                                                      |
| `navigation/sidebar-navigation`   |        5 | Pattern — Embedded in the sidebar-shell reference           |
| `navigation/tabs`                 |        9 | Adapted — Status and category filters                       |
| `navigation/vertical-navigation`  |        6 | Adapted — Module groups and editor section anchors          |
| `overlays/drawers`                |       12 | Adapted — Picture details inspector                         |
| `overlays/modal-dialogs`          |        6 | Adapted — Deletion confirmation and ordering                |
| `overlays/notifications`          |        6 | Unused                                                      |
| `page-examples/detail-screens`    |        2 | Unused                                                      |
| `page-examples/home-screens`      |        2 | Unused                                                      |
| `page-examples/settings-screens`  |        2 | Unused                                                      |

## Category radios, mobile tables and headings

| Template                                              | Render location and behavior                                                                                                                                                                                                                                                                                           |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `forms/radio-groups/02-simple-inline-list.html`       | `app/views/admin/shared/_radio_group.html.erb`, dispatched by `_field.html.erb` for people/news `category` and publication `category_status`. The field configuration retains `type: select` and opts into `presentation: radio`; blank choices and stored values are preserved.                                       |
| `lists/tables/07-with-stacked-columns-on-mobile.html` | `app/views/admin/resources/index.html.erb` and `app/views/admin/shared/_table_value.html.erb`. Works, people, news, publications, portfolios, journals, administrators, cities and branch contacts stack secondary fields below the primary name/title below 640px. Ordering and row actions have one set of controls. |
| `headings/card-headings/01-simple.html`               | `app/views/admin/shared/_card_heading.html.erb`, used by the dashboard module groups with an h3 and module count.                                                                                                                                                                                                      |
| `headings/card-headings/05-with-description.html`     | The same card-heading partial, used by resource and message details with an h2 and record/language description.                                                                                                                                                                                                        |
| `headings/section-headings/04-with-action.html`       | `app/views/admin/shared/_section_heading.html.erb`, used by the homepage carousel editor for its live count, save-time guidance and Add slide button.                                                                                                                                                                  |

All other unused families remain unused; this adoption introduces no new workflows,
routes, database changes or runtime dependencies. A family marked Adapted uses only
the specific variants documented in [Admin UI templates](admin-ui.md), not every
variant in that family.

The blank publication category remains selectable but cannot be saved, matching
the existing database constraint. The admin model now returns an inline error;
people and news categories can still be cleared.
