import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "bgImg", "introDiv" ]

  resize() {
    if (this.bgImgTarget.height >= window.innerHeight) {
      this.introDivTarget.classList.add("bg-thape-white-t80");
    } else {
      this.introDivTarget.classList.remove("bg-thape-white-t80");
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
