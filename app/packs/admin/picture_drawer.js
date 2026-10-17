const drawer = document.querySelector("[data-admin-picture-drawer]")
if (drawer && typeof drawer.showModal === "function") {
  const content = drawer.querySelector("[data-admin-picture-content]")
  let opener = null
  let request = null
  let generation = 0
  document.addEventListener("click", async (event) => {
    const link = event.target.closest("a[data-admin-picture-open]")
    if (!link || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return
    event.preventDefault()
    request?.abort()
    request = new AbortController()
    const current = ++generation
    opener = link
    content.textContent = drawer.dataset.loading
    content.setAttribute("aria-busy", "true")
    drawer.showModal()
    drawer.querySelector("[data-admin-picture-close]").focus()
    try {
      const response = await fetch(link.href, {
        signal: request.signal,
        headers: { "X-Requested-With": "XMLHttpRequest" },
      })
      if (!response.ok || response.redirected) throw new Error("Picture unavailable")
      const html = await response.text()
      if (current !== generation) return
      content.innerHTML = html
      content.querySelectorAll("[data-admin-media-image]").forEach((img) => {
        const fallback = () => {
          img.hidden = true
          img.parentElement.querySelector("[data-admin-media-placeholder]").hidden = false
        }
        img.addEventListener("error", fallback)
        if (img.complete && !img.naturalWidth) fallback()
      })
    } catch (error) {
      if (error.name === "AbortError" || current !== generation) return
      const message = document.createElement("p")
      message.className = "admin-alert admin-alert-error"
      message.role = "alert"
      message.textContent = drawer.dataset.failed
      const fallback = document.createElement("a")
      fallback.href = link.href
      fallback.className = "admin-link"
      fallback.textContent = drawer.dataset.fallback
      content.replaceChildren(message, fallback)
    } finally {
      if (current === generation) content.removeAttribute("aria-busy")
    }
  })
  drawer.querySelector("[data-admin-picture-close]").addEventListener("click", () => drawer.close())
  drawer.addEventListener("click", (event) => {
    if (event.target === drawer) drawer.close()
  })
  drawer.addEventListener("close", () => {
    generation += 1
    request?.abort()
    content.replaceChildren()
    content.removeAttribute("aria-busy")
    if (opener?.isConnected) opener.focus()
  })
}
