document.querySelectorAll("[data-admin-record-picker]").forEach((picker) => {
  const canonical = picker.querySelector("[data-admin-picker-id]")
  const controls = picker.querySelector("[data-admin-picker-controls]")
  const input = picker.querySelector("[data-admin-picker-search]")
  const list = picker.querySelector('[role="listbox"]')
  const status = picker.querySelector("[data-admin-picker-status]")
  const label = document.querySelector(`label[for="${canonical.id}"]`)
  let selectedText = input.value
  let active = -1
  let options = []
  let request = null
  let timer = null
  let generation = 0

  const close = () => {
    generation += 1
    clearTimeout(timer)
    request?.abort()
    list.hidden = true
    input.setAttribute("aria-expanded", "false")
    input.removeAttribute("aria-activedescendant")
    active = -1
  }
  const highlight = (index) => {
    active = index
    Array.from(list.children).forEach((item, i) => item.setAttribute("aria-selected", String(i === index)))
    if (index >= 0) {
      input.setAttribute("aria-activedescendant", list.children[index].id)
      list.children[index].scrollIntoView({ block: "nearest" })
    }
  }
  const select = (option) => {
    canonical.value = option.id
    input.value = `${option.label} · #${option.id}`
    selectedText = input.value
    input.setCustomValidity("")
    status.textContent =
      option.published === null ? "" : option.published ? picker.dataset.published : picker.dataset.unpublished
    canonical.dispatchEvent(new Event("change", { bubbles: true }))
    close()
    input.focus()
  }
  const search = async () => {
    request?.abort()
    request = new AbortController()
    const current = ++generation
    status.textContent = picker.dataset.loading
    list.replaceChildren()
    list.hidden = true
    input.setAttribute("aria-expanded", "false")
    input.removeAttribute("aria-activedescendant")
    active = -1
    try {
      const url = new URL(picker.dataset.url, window.location.origin)
      url.searchParams.set("q", input.value === selectedText ? "" : input.value)
      const response = await fetch(url, { signal: request.signal, headers: { Accept: "application/json" } })
      if (!response.ok || response.redirected) throw new Error("Lookup failed")
      const result = await response.json()
      if (current !== generation) return
      options = result.options
      options.forEach((option, index) => {
        const item = document.createElement("li")
        item.id = `${list.id}_${index}`
        item.role = "option"
        item.setAttribute("aria-selected", "false")
        const title = document.createElement("span")
        title.textContent = option.label
        const detail = document.createElement("span")
        detail.className = "admin-picker-secondary"
        detail.textContent = `#${option.id}${option.published === null ? "" : ` · ${option.published ? picker.dataset.published : picker.dataset.unpublished}`}`
        item.append(title, detail)
        // Keep focus in the combobox so a pointer selection precedes blur handling.
        item.addEventListener("mousedown", (event) => event.preventDefault())
        item.addEventListener("click", () => select(option))
        list.append(item)
      })
      list.hidden = options.length === 0
      input.setAttribute("aria-expanded", String(options.length > 0))
      status.textContent = options.length ? "" : picker.dataset.empty
    } catch (error) {
      if (error.name !== "AbortError" && current === generation) status.textContent = picker.dataset.failed
    }
  }
  controls.hidden = false
  canonical.hidden = true
  if (label) label.htmlFor = input.id
  for (const attribute of ["aria-describedby", "aria-invalid"]) {
    if (canonical.hasAttribute(attribute)) input.setAttribute(attribute, canonical.getAttribute(attribute))
  }
  input.addEventListener("input", () => {
    close()
    if (!input.value) {
      canonical.value = ""
      selectedText = ""
    }
    input.setCustomValidity(input.value === selectedText ? "" : picker.dataset.pending)
    timer = setTimeout(search, 200)
  })
  input.addEventListener("focus", search)
  input.addEventListener("click", () => {
    if (list.hidden) search()
  })
  input.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      event.preventDefault()
      close()
    } else if (["ArrowDown", "ArrowUp"].includes(event.key)) {
      event.preventDefault()
      if (list.hidden) search()
      else if (active < 0) highlight(event.key === "ArrowDown" ? 0 : options.length - 1)
      else highlight((active + (event.key === "ArrowDown" ? 1 : -1) + options.length) % options.length)
    } else if (event.key === "Enter" && !list.hidden) {
      event.preventDefault()
      if (active >= 0) select(options[active])
    }
  })
  picker.querySelector("[data-admin-picker-clear]").addEventListener("click", () => {
    canonical.value = ""
    selectedText = ""
    input.value = ""
    input.setCustomValidity("")
    status.textContent = ""
    close()
    input.focus()
  })
  picker.addEventListener("focusout", () => {
    setTimeout(() => {
      if (!picker.contains(document.activeElement)) close()
    }, 0)
  })
})
