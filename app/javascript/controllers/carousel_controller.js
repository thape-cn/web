import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "nextSlide" ]

  connect() {
    if (this.data.has("refreshInterval")) {
      this.start_rotate()
    }
  }

  disconnect() {
    this.stop_rotate()
  }

  start_rotate() {
    window.clearInterval(window.refreshTimer);
    window.refreshTimer = window.setInterval(() => {
      this.nextSlideTarget.click();
    }, this.data.get("refreshInterval"))
  }

  stop_rotate() {
    window.clearInterval(window.refreshTimer);
  }
}
