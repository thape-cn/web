import Rails from "@rails/ujs"
import "stylesheets/admin/application.scss"
import "images/logo.svg"

Rails.start()

const navigation = document.getElementById("admin-navigation")
const menuButton = document.querySelector("[data-admin-menu-open]")
const revealCurrentPage = container => {
  const current = container.querySelector('[aria-current="page"]')
  if (current) current.scrollIntoView({ block: "nearest" })
}

document.querySelectorAll(".admin-sidebar nav").forEach(revealCurrentPage)

if (navigation && menuButton) {
  menuButton.addEventListener("click", () => {
    navigation.showModal()
    revealCurrentPage(navigation)
    menuButton.setAttribute("aria-expanded", "true")
    document.body.classList.add("admin-menu-open")
  })

  navigation.querySelector("[data-admin-menu-close]").addEventListener("click", () => navigation.close())
  navigation.addEventListener("click", event => {
    if (event.target === navigation) {
      const bounds = navigation.getBoundingClientRect()
      if (event.clientX < bounds.left || event.clientX > bounds.right || event.clientY < bounds.top || event.clientY > bounds.bottom) navigation.close()
    }
  })
  navigation.addEventListener("close", () => {
    menuButton.setAttribute("aria-expanded", "false")
    document.body.classList.remove("admin-menu-open")
    menuButton.focus()
  })

  // Close the modal when the persistent desktop navigation becomes available.
  window.matchMedia("(min-width: 1024px)").addEventListener("change", event => {
    if (event.matches && navigation.open) navigation.close()
  })
}
