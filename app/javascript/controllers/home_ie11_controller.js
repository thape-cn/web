import { Controller } from "stimulus"

let wallPapers = [];
let activeSlide = 0;

export default class extends Controller {
  connect() {
    wallPapers = JSON.parse(this.data.get("wallpapers"));

    if (this.data.has("refreshInterval")) {
      this.start_rotate()
    }
  }

  disconnect() {
    this.stop_rotate();
  }

  layout() {

  }

  prev_slide() {
    activeSlide = activeSlide === 0 ? (wallPapers.length - 1) : activeSlide - 1;

    const wp = wallPapers[activeSlide];
    document.body.style.backgroundImage = `url('${wp}')`;
  }

  next_slide() {
    activeSlide = activeSlide === (wallPapers.length - 1) ? 0 : activeSlide + 1;
    const wp = wallPapers[activeSlide];
    document.body.style.backgroundImage = `url('${wp}')`;
  }

  start_rotate() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
    this.refreshTimer = setInterval(() => {
      this.next_slide();
    }, this.data.get("refreshInterval"))
  }

  stop_rotate() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
