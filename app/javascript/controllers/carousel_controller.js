import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "nextSlide" ]

  connect() {
    if (this.data.has("refreshInterval")) {
      this.start_rotate()
    }
    if (this.data.has("turnWhite")) {
      setTimeout(() => {
        nav_menu.turnWhite();
      }, 200);
    }
    if (this.data.has("turnTransparent")) {
      setTimeout(() => {
        nav_menu.turnTransparent();
      }, 200);
    }
  }

  disconnect() {
    this.stop_rotate()
  }

  start_rotate() {
    this.refreshTimer = setInterval(() => {
      this.nextSlideTarget.click();
    }, this.data.get("refreshInterval"))
  }

  stop_rotate() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
