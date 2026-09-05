import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["marker", "city", "company", "cityPanel", "companyPanel"];

  connect() {
    this.reset();
  }

  selectCity(event) {
    if (!this.activate(event)) return;
    this.city = event.currentTarget.dataset.city;
    this.company = "";
    this.render();
  }

  selectCompany(event) {
    if (!this.activate(event)) return;
    this.city = event.currentTarget.dataset.city;
    this.company = event.currentTarget.dataset.company;
    this.render();
  }

  activate(event) {
    if (event.type !== "keydown") return true;
    if (event.key !== "Enter" && event.key !== " ") return false;
    event.preventDefault();
    return true;
  }

  closeCompany() {
    this.company = "";
    this.render();
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
  }

  highlight(element, active) {
    element.dataset.activeClass.split(" ").forEach(name => element.classList.toggle(name, active));
    element.dataset.inactiveClass.split(" ").forEach(name => element.classList.toggle(name, !active));
    if (element.getAttribute("role") === "button") element.setAttribute("aria-pressed", String(active));
  }
}
