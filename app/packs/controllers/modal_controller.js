import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["panel"];

  open(event) {
    this.opener = event.currentTarget;
    this.panelTarget.hidden = false;
    this.previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    this.panelTarget.querySelector("input:not([type=hidden]):not(:disabled), button:not(:disabled)").focus();
  }

  close() {
    if (this.panelTarget.hidden) return;
    this.panelTarget.hidden = true;
    document.body.style.overflow = this.previousOverflow;
    if (this.opener) this.opener.focus();
  }

  keydown(event) {
    if (this.panelTarget.hidden) return;
    if (event.key === "Escape") this.close();
    if (event.key !== "Tab") return;

    const focusable = Array.from(this.panelTarget.querySelectorAll("button, input, textarea, a[href], [tabindex='0']"))
      .filter(element => !element.disabled && element.getClientRects().length);
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  }

  disconnect() {
    if (!this.panelTarget.hidden) document.body.style.overflow = this.previousOverflow;
  }
}
