// Rails UJS still owns submission, method spoofing, and CSRF. Without this
// enhancement its original data-confirm behavior remains available.
const dialog = document.getElementById("admin-confirmation")

if (dialog && typeof dialog.showModal === "function") {
  const cancel = dialog.querySelector("[data-admin-confirm-cancel]")
  const accept = dialog.querySelector("[data-admin-confirm-accept]")
  let pending = null
  let opener = null
  cancel.addEventListener("click", () => dialog.close())
  accept.addEventListener("click", () => {
    if (!pending || accept.disabled) return
    accept.disabled = true
    const element = pending
    const message = element.getAttribute("data-confirm")
    pending = null
    dialog.close()
    element.removeAttribute("data-confirm")
    try {
      element.click()
    } finally {
      element.setAttribute("data-confirm", message)
    }
  })
  dialog.addEventListener("close", () => {
    pending = null
    if (opener?.isConnected) opener.focus()
  })
  document.addEventListener("confirm", event => {
    const element = event.target
    if (typeof dialog.showModal !== "function") return
    if (!element.matches(".admin-danger-link[data-confirm]")) return
    if (dialog.open) {
      event.preventDefault()
      return
    }
    dialog.querySelector("#admin-confirmation-message").textContent = element.getAttribute("data-confirm")
    accept.disabled = false
    opener = element
    dialog.showModal()
    pending = element
    cancel.focus()
    event.preventDefault()
  })
}
