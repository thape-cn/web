import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["option", "value", "summary"];
  static values = { separator: String, placeholder: String };

  connect() {
    this.selected = this.optionTargets.filter(option => option.checked).map(option => option.value);
    this.render();
  }

  change(event) {
    const option = event.target;
    this.selected = this.selected.filter(value => value !== option.value);
    if (option.checked) this.selected.push(option.value);
    this.render();
  }

  render() {
    const value = this.selected.join(this.separatorValue);
    this.valueTarget.value = value;
    this.summaryTarget.textContent = value || this.placeholderValue;
  }
}
