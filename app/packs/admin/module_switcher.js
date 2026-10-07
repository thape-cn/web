const dialog = document.getElementById("admin-module-search")
const button = document.querySelector("[data-admin-switcher-open]")

if (dialog && button && typeof dialog.showModal === "function") {
  const input = dialog.querySelector("input")
  const items = Array.from(dialog.querySelectorAll("[data-admin-command-item]"))
  let opener = null
  let selected = null
  const visibleLinks = () => items.filter((item) => !item.hidden).map((item) => item.querySelector("a"))
  const select = (link) => {
    if (selected) selected.classList.remove("admin-command-active")
    selected = link
    if (selected) selected.classList.add("admin-command-active")
  }
  const filter = () => {
    const query = input.value.trim().toLocaleLowerCase()
    items.forEach((item) => {
      item.hidden = !item.dataset.search.toLocaleLowerCase().includes(query)
    })
    dialog.querySelectorAll("[data-admin-command-group]").forEach((group) => {
      group.hidden = !Array.from(group.querySelectorAll("[data-admin-command-item]")).some((item) => !item.hidden)
    })
    dialog.querySelector("[data-admin-command-empty]").hidden = visibleLinks().length > 0
    select(null)
  }
  const open = (event) => {
    if (document.querySelector("dialog[open]")) return
    opener = event?.currentTarget === button ? button : document.activeElement
    input.value = ""
    filter()
    dialog.showModal()
    input.focus()
  }
  button.addEventListener("click", open)
  dialog.querySelector("[data-admin-switcher-close]").addEventListener("click", () => dialog.close())
  input.addEventListener("input", filter)
  dialog.addEventListener("keydown", (event) => {
    // Search inputs consume Escape to clear their value in Chrome. Close the
    // palette explicitly so dismissal works regardless of the focused control.
    if (event.key === "Escape") {
      event.preventDefault()
      dialog.close()
      return
    }
    const links = visibleLinks()
    if (["ArrowDown", "ArrowUp"].includes(event.key) && links.length) {
      event.preventDefault()
      const current = links.indexOf(document.activeElement)
      const next =
        event.key === "ArrowDown"
          ? (current + 1) % links.length
          : current < 0
            ? links.length - 1
            : (current - 1 + links.length) % links.length
      select(links[next])
      links[next].focus()
      links[next].scrollIntoView({ block: "nearest" })
    } else if (event.key === "Enter" && event.target === input && links.length) {
      event.preventDefault()
      links[0].click()
    }
  })
  dialog.addEventListener("close", () => {
    select(null)
    if (opener?.isConnected) opener.focus()
  })
  document.addEventListener("keydown", (event) => {
    if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k") {
      event.preventDefault()
      if (dialog.open) dialog.close()
      else open()
    }
  })
  button.hidden = false
}
