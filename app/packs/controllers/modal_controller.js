import { Controller } from "stimulus";
import { lockScroll, unlockScroll, isTopScrollLock } from "../helpers/scroll_lock";

export default class extends Controller {
  static targets = ["panel"];

  open(event) {
    if (!this.panelTarget.hidden) return;
    this.opener = event.currentTarget;
    this.panelTarget.hidden = false;
    lockScroll(this, () => this.close(false));
    this.panelTarget.querySelector("input:not([type=hidden]):not(:disabled), button:not(:disabled)").focus({preventScroll: true});
  }

  close(restoreFocus = true) {
    const wasTop = isTopScrollLock(this);
    this.panelTarget.hidden = true;
    unlockScroll(this);
    if (restoreFocus && wasTop && this.opener?.isConnected) this.opener.focus({preventScroll: true});
  }

  keydown(event) {
    if (this.panelTarget.hidden || event.defaultPrevented || !isTopScrollLock(this)) return;
    if (event.key === "Escape") {
      event.preventDefault();
      this.close();
      return;
    }
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
    this.close(false);
  }
}
