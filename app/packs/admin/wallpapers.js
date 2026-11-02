import { initializeUploads } from "./uploads"

document.querySelectorAll("[data-admin-wallpapers]").forEach((form) => {
  const editor = form.querySelector("[data-wallpaper-editor]")
  const list = editor.querySelector("[data-wallpaper-list]")
  const template = editor.querySelector("[data-wallpaper-template]")
  const add = editor.querySelector("[data-wallpaper-add]")
  const navigation = form.querySelector(".admin-section-navigation ul")
  const navigationIcon = navigation?.querySelector("svg")?.cloneNode(true)
  const minimum = Number(editor.dataset.min)
  const maximum = Number(editor.dataset.max)
  let nextIndex = list.children.length
  const slides = () => Array.from(list.children).filter((slide) => !slide.hidden)

  const refresh = () => {
    const active = slides()
    add.hidden = false
    add.disabled = active.length >= maximum
    editor.querySelector("[data-wallpaper-count]").textContent = editor.dataset.countLabel.replace(
      "__COUNT__",
      active.length,
    )
    navigation?.replaceChildren()
    list.querySelectorAll("[data-wallpaper-slide][hidden] h2").forEach((heading) => heading.removeAttribute("id"))
    active.forEach((slide, index) => {
      const label = editor.dataset.slideLabel.replace("__NUMBER__", index + 1)
      const heading = slide.querySelector("h2")
      heading.textContent = label
      heading.id = `wallpaper-${index + 1}-heading`
      slide.querySelector("section").setAttribute("aria-labelledby", heading.id)
      slide.querySelector("[data-wallpaper-position]").value = index + 1
      slide.querySelector("[data-wallpaper-actions]").hidden = false
      slide.querySelector("[data-wallpaper-up]").disabled = index === 0
      slide.querySelector("[data-wallpaper-down]").disabled = index === active.length - 1
      slide.querySelector("[data-wallpaper-remove]").disabled = active.length <= minimum
      if (navigation) {
        const item = document.createElement("li")
        const link = document.createElement("a")
        link.href = `#${heading.id}`
        if (navigationIcon) link.append(navigationIcon.cloneNode(true))
        link.append(label)
        item.append(link)
        navigation.append(item)
      }
    })
  }

  add.addEventListener("click", () => {
    if (slides().length >= maximum) return
    list.insertAdjacentHTML("beforeend", template.innerHTML.replaceAll("NEW_WALLPAPER", nextIndex++))
    const slide = list.lastElementChild
    initializeUploads(slide)
    refresh()
    slide.querySelector('input[type="text"]').focus()
  })

  list.addEventListener("click", (event) => {
    const button = event.target.closest("button")
    const slide = button?.closest("[data-wallpaper-slide]")
    if (!slide) return
    const active = slides()
    const index = active.indexOf(slide)
    if (button.hasAttribute("data-wallpaper-remove") && active.length > minimum) {
      slide.querySelector("[data-wallpaper-destroy]").value = "1"
      slide.hidden = true
      // Hidden removed cards must not leave duplicate anchor IDs behind.
      slide.querySelector("h2").removeAttribute("id")
      const next = active[index + 1] || active[index - 1]
      next.querySelector('input[type="text"]').focus()
    } else if (button.hasAttribute("data-wallpaper-up") && index > 0) {
      list.insertBefore(slide, active[index - 1])
    } else if (button.hasAttribute("data-wallpaper-down") && index < active.length - 1) {
      list.insertBefore(active[index + 1], slide)
    } else {
      return
    }
    refresh()
  })

  refresh()
})
