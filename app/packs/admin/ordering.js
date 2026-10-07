const table = document.querySelector("[data-admin-order-table]")
const form = document.querySelector("[data-admin-drag-form]")

if (table && form) {
  let source = null
  let target = null
  let saving = false

  const clearTarget = () => {
    if (target) target.classList.remove("admin-drop-before", "admin-drop-after")
    target = null
  }
  const reset = () => {
    clearTarget()
    if (source) source.classList.remove("admin-dragging")
    source = null
  }

  table.querySelectorAll("[data-admin-drag-handle]").forEach((handle) => {
    handle.hidden = false
  })
  document.querySelector("[data-admin-drag-hint]").hidden = false

  table.addEventListener("dragstart", (event) => {
    const handle = event.target.closest("[data-admin-drag-handle]")
    if (!handle || saving) {
      event.preventDefault()
      return
    }
    source = handle.closest("[data-record-id]")
    source.classList.add("admin-dragging")
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", source.dataset.recordId)
    event.dataTransfer.setDragImage(source, 30, 20)
  })

  table.addEventListener("dragover", (event) => {
    if (!source || saving) return
    clearTarget()
    const row = event.target.closest("[data-record-id]")
    if (!row || row === source) return
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    target = row
    const bounds = row.getBoundingClientRect()
    const movement = event.clientY < Math.floor(bounds.top + bounds.height / 2) ? "before" : "after"
    row.classList.add(`admin-drop-${movement}`)
  })

  table.addEventListener("dragleave", (event) => {
    if (!table.contains(event.relatedTarget)) clearTarget()
  })
  table.addEventListener("dragend", reset)
  table.addEventListener("drop", (event) => {
    const row = event.target.closest("[data-record-id]")
    if (!source || !row || row === source || saving) return
    event.preventDefault()
    const bounds = row.getBoundingClientRect()
    form.action = source.dataset.reorderUrl
    form.elements.movement.value = event.clientY < Math.floor(bounds.top + bounds.height / 2) ? "before" : "after"
    form.elements.target_id.value = row.dataset.recordId
    saving = true
    table.setAttribute("aria-busy", "true")
    reset()
    form.requestSubmit()
  })

  const dialog = document.querySelector("[data-admin-order-dialog]")
  const content = dialog.querySelector("[data-admin-order-content]")
  let activeMenu = null
  table.querySelectorAll(".admin-order-menu summary").forEach((summary) => {
    summary.setAttribute("aria-haspopup", "dialog")
    summary.setAttribute("aria-controls", dialog.id)
    summary.addEventListener("click", (event) => {
      // Keep the inline details/forms available when native dialogs are unavailable.
      if (typeof dialog.showModal !== "function") return
      event.preventDefault()
      if (dialog.open) return
      activeMenu = summary.parentElement
      content.appendChild(activeMenu.querySelector(".admin-order-panel"))
      summary.setAttribute("aria-expanded", "true")
      dialog.showModal()
    })
  })
  dialog.querySelector("[data-admin-order-close]").addEventListener("click", () => dialog.close())
  dialog.addEventListener("close", () => {
    if (!activeMenu) return
    activeMenu.appendChild(content.firstElementChild)
    activeMenu.querySelector("summary").setAttribute("aria-expanded", "false")
    activeMenu.querySelector("summary").focus()
    activeMenu = null
  })
}
