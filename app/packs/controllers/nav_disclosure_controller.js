import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["trigger", "panel"]

  connect() {
    this.syncExpanded()
  }

  open() {
    this.element.classList.remove("nav-dismissed")
    this.syncExpanded()
  }

  syncExpanded() {
    this.setExpanded(this.element.contains(document.activeElement))
  }

  blur(event) {
    this.setExpanded(this.element.contains(event.relatedTarget))
  }

  setExpanded(focused) {
    const expanded = !this.element.classList.contains("nav-dismissed") && (focused || this.element.matches(":hover"))
    this.triggerTarget.setAttribute("aria-expanded", String(expanded))
  }

  keydown(event) {
    if (event.key === "ArrowDown" && event.target === this.triggerTarget) {
      event.preventDefault()
      this.open()
      this.panelTarget.querySelector("a[href]")?.focus()
    } else if (event.key === "Escape" && this.triggerTarget.getAttribute("aria-expanded") === "true") {
      event.preventDefault()
      event.stopPropagation()
      this.triggerTarget.focus()
      this.element.classList.add("nav-dismissed")
      this.triggerTarget.setAttribute("aria-expanded", "false")
    }
  }
}
