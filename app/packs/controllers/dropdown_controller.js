import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["trigger", "panel"];

  connect() {
    this.close();
  }

  toggle() {
    this.panelTarget.hidden = !this.panelTarget.hidden;
    this.triggerTarget.setAttribute("aria-expanded", String(!this.panelTarget.hidden));
  }

  close() {
    this.panelTarget.hidden = true;
    this.triggerTarget.setAttribute("aria-expanded", "false");
  }

  dismiss(event) {
    if (!this.element.contains(event.target)) this.close();
  }

  keydown(event) {
    if (event.key === "Escape" && !this.panelTarget.hidden) {
      this.close();
      this.triggerTarget.focus();
    }
  }
}
