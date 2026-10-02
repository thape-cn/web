import { Controller } from "stimulus";
import { lockScroll, unlockScroll, isTopScrollLock } from "../helpers/scroll_lock";

export default class extends Controller {
  static targets = ["marker", "city", "company", "cityPanel", "companyPanel"];

  connect() {
    this.desktop = window.matchMedia("(min-width: 1280px)");
    this.desktop.addEventListener("change", this.closeOnDesktop);
    document.addEventListener("keydown", this.keydown);
    this.reset();
  }

  disconnect() {
    this.closeCompany(null, false);
    this.desktop.removeEventListener("change", this.closeOnDesktop);
    document.removeEventListener("keydown", this.keydown);
  }

  closeOnDesktop = () => {
    if (this.desktop.matches) this.closeCompany(null, false);
  }

  selectCity(event) {
    if (!this.activate(event)) return;
    this.city = event.currentTarget.dataset.city;
    this.company = "";
    this.render();
  }

  selectCompany(event) {
    if (!this.activate(event)) return;
    this.companyOpener = event.currentTarget;
    this.city = event.currentTarget.dataset.city;
    this.company = event.currentTarget.dataset.company;
    // Capture the position before revealing the matching office section below the map.
    if (!this.desktop.matches) lockScroll(this, () => this.closeCompany(null, false));
    this.render();
    this.mobilePanel()?.querySelector("button").focus({preventScroll: true});
  }

  activate(event) {
    if (event.type !== "keydown") return true;
    if (event.key !== "Enter" && event.key !== " ") return false;
    event.preventDefault();
    return true;
  }

  dismissCompany(event) {
    if (event.target === event.currentTarget) this.closeCompany();
  }

  closeCompany(event, restoreFocus = true) {
    const wasTop = isTopScrollLock(this);
    this.company = "";
    this.render();
    if (restoreFocus && wasTop && this.companyOpener?.isConnected) this.companyOpener.focus({preventScroll: true});
  }

  mobilePanel() {
    if (this.desktop.matches) return null;
    return this.companyPanelTargets.find(element => !element.hidden && element.classList.contains("mobile-company-panel"));
  }

  keydown = event => {
    const panel = this.mobilePanel();
    if (!panel || event.defaultPrevented || !isTopScrollLock(this)) return;
    if (event.key === "Escape") {
      event.preventDefault();
      this.closeCompany();
    } else if (event.key === "Tab") {
      const links = Array.from(panel.querySelectorAll("button, a[href]"));
      const first = links[0];
      const last = links[links.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    }
  }

  reset() {
    this.city = "";
    this.company = "";
    this.render();
  }

  render() {
    this.markerTargets.concat(this.cityTargets).forEach(element => {
      this.highlight(element, element.dataset.city === this.city);
    });
    this.companyTargets.forEach(element => this.highlight(element, element.dataset.company === this.company));
    this.cityPanelTargets.forEach(element => { element.hidden = element.dataset.city !== this.city; });
    this.companyPanelTargets.forEach(element => { element.hidden = element.dataset.company !== this.company; });
    if (this.mobilePanel()) lockScroll(this, () => this.closeCompany(null, false));
    else unlockScroll(this);
  }

  highlight(element, active) {
    element.dataset.activeClass.split(" ").forEach(name => element.classList.toggle(name, active));
    element.dataset.inactiveClass.split(" ").forEach(name => element.classList.toggle(name, !active));
    if (element.getAttribute("role") === "button") element.setAttribute("aria-pressed", String(active));
  }
}
