document.querySelectorAll("[data-admin-alert-dismiss]").forEach((button) => {
  button.hidden = false
  button.addEventListener("click", () => {
    button.closest("[data-admin-alert]").remove()
    document.getElementById("main").focus()
  })
})

// Native dialogs keep their existing close/focus handlers when the backdrop is used.
document.querySelectorAll(".admin-dialog").forEach((dialog) => {
  dialog.addEventListener("click", (event) => {
    if (event.target !== dialog) return
    const bounds = dialog.getBoundingClientRect()
    if (
      event.clientX < bounds.left ||
      event.clientX > bounds.right ||
      event.clientY < bounds.top ||
      event.clientY > bounds.bottom
    )
      dialog.close()
  })
})

document.querySelectorAll("[data-admin-media-image]").forEach((img) => {
  const showPlaceholder = () => {
    img.hidden = true
    img.parentElement.querySelector("[data-admin-media-placeholder]").hidden = false
  }
  img.addEventListener("error", showPlaceholder)
  if (img.complete && img.naturalWidth === 0) showPlaceholder()
})
