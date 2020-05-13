import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "bgImg", "introDiv" ]

  resize() {
    if (this.bgImgTarget.height >= window.innerHeight) {
      this.introDivTarget.classList.add("opacity-75");
    } else {
      this.introDivTarget.classList.remove("opacity-75");
    }
  }

  connect() {
    setTimeout(() => {
      this.resize();
    }, 200)
  }

  layout() {
    this.resize();
  }
}
