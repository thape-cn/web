document.querySelectorAll("[data-admin-alert-dismiss]").forEach((button) => {
  button.hidden = false
  button.addEventListener("click", () => {
    button.closest("[data-admin-alert]").remove()
    document.getElementById("main").focus()
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
