# Admin component inventory

The local `application-ui-v4/html` library contains 49 families and 364 HTML
templates. The initial source audit found 23 explicitly mapped families (29
variants). After the record-picker, picture-inspector and message-workflow additions,
30 families have explicit source mappings (36 variants); 9 more have embedded or
custom patterns, and 10 remain unused.

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
| `forms/radio-groups`              |       12 | Unused                                                      |
| `forms/select-menus`              |        7 | Adapted — Editors, filters, ordering and page size          |
| `forms/sign-in-forms`             |        4 | Adapted — Administrator login                               |
| `forms/textareas`                 |        5 | Pattern — Native and rich-text editor fields                |
| `forms/toggles`                   |        5 | Adapted — Publication and visibility fields                 |
| `headings/card-headings`          |        6 | Pattern — Headings supplied by card/detail templates        |
| `headings/page-headings`          |        9 | Adapted — Page titles, actions and breadcrumbs              |
| `headings/section-headings`       |       10 | Pattern — Dashboard and editor section titles               |
| `layout/cards`                    |       10 | Adapted — Dashboard groups and shared panels                |
| `layout/containers`               |        5 | Pattern — Responsive shell content width and gutters        |
| `layout/dividers`                 |        8 | Pattern — Borders within existing lists, cards and forms    |
| `layout/list-containers`          |        7 | Adapted — Message inbox container                           |
| `layout/media-objects`            |        8 | Pattern — Account block and icon/text shortcuts             |
| `lists/feeds`                     |        3 | Unused                                                      |
| `lists/grid-lists`                |        7 | Adapted — Dashboard shortcuts, picture grids and galleries  |
| `lists/stacked-lists`             |       15 | Adapted — Message inbox previews                            |
| `lists/tables`                    |       19 | Adapted — Resource lists and message table view             |
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
