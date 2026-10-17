const bulk = document.querySelector("[data-admin-message-bulk]")
if (bulk) {
  const checkboxes = Array.from(document.querySelectorAll("[data-admin-message-select]"))
  const all = bulk.querySelector("[data-admin-select-page]")
  const button = bulk.querySelector("[data-admin-bulk-delete]")
  const count = bulk.querySelector("[data-admin-message-count]")
  count.hidden = false
  const update = () => {
    const selected = checkboxes.filter((checkbox) => checkbox.checked).length
    count.textContent = bulk.dataset.selected.replace("__COUNT__", selected)
    button.dataset.confirm = bulk.dataset.confirmTemplate.replace("__COUNT__", selected)
    button.disabled = selected === 0
    all.checked = selected === checkboxes.length
    all.indeterminate = selected > 0 && selected < checkboxes.length
  }
  bulk.querySelector("[data-admin-select-page-label]").hidden = false
  all.addEventListener("change", () => {
    checkboxes.forEach((checkbox) => {
      checkbox.checked = all.checked
    })
    update()
  })
  checkboxes.forEach((checkbox) => checkbox.addEventListener("change", update))
  window.addEventListener("pageshow", () => {
    all.checked = false
    checkboxes.forEach((checkbox) => {
      checkbox.checked = false
    })
    update()
  })
  update()
}
