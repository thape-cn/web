const menus = () => document.querySelectorAll("[data-admin-action-menu]")
const position = (menu) => {
  const summary = menu.querySelector("summary")
  const panel = menu.querySelector(".admin-action-menu-items")
  const anchor = summary.getBoundingClientRect()
  panel.style.position = "fixed"
  panel.style.right = "auto"
  panel.style.left = `${Math.max(8, Math.min(anchor.right - panel.offsetWidth, innerWidth - panel.offsetWidth - 8))}px`
  panel.style.top = `${Math.max(8, anchor.bottom + panel.offsetHeight > innerHeight - 8 ? anchor.top - panel.offsetHeight : anchor.bottom)}px`
}

document.addEventListener(
  "toggle",
  (event) => {
    const menu = event.target
    if (!menu.matches?.("[data-admin-action-menu]")) return
    menu.querySelector("summary").setAttribute("aria-expanded", String(menu.open))
    if (menu.open) {
      menus().forEach((other) => {
        if (other !== menu) other.open = false
      })
      position(menu)
    }
  },
  true,
)

document.addEventListener("click", (event) => {
  if (event.target.closest("#admin-confirmation")) return
  menus().forEach((menu) => {
    if (!menu.contains(event.target)) menu.open = false
  })
})
document.addEventListener("keydown", (event) => {
  const menu = event.target.closest("[data-admin-action-menu]")
  if (!menu) return
  if (event.key === "Escape" && menu.open) {
    event.preventDefault()
    event.stopPropagation()
    menu.open = false
    menu.querySelector("summary").focus()
  } else if (["ArrowDown", "ArrowUp", "Home", "End"].includes(event.key)) {
    event.preventDefault()
    menu.open = true
    position(menu)
    const items = Array.from(menu.querySelectorAll("a, button"))
    const current = items.indexOf(document.activeElement)
    const index =
      event.key === "Home"
        ? 0
        : event.key === "End"
          ? items.length - 1
          : (current + (event.key === "ArrowDown" ? 1 : -1) + items.length) % items.length
    items[index]?.focus()
  }
})
window.addEventListener("resize", () =>
  menus().forEach((menu) => {
    menu.open = false
  }),
)
document.addEventListener(
  "scroll",
  () =>
    menus().forEach((menu) => {
      menu.open = false
    }),
  true,
)
