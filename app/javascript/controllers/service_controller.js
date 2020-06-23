import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "bgImg", "introDiv" ]

  resize() {
    if (this.bgImgTarget.offsetHeight >= this.element.offsetHeight) {
      this.introDivTarget.classList.add("bg-thape-white-t80", 'absolute');
      this.introDivTarget.classList.remove("bg-white", 'flex', 'content-center', 'flex-auto');
    } else {
      this.introDivTarget.classList.remove("bg-thape-white-t80");
      this.introDivTarget.classList.add("bg-white");
      if (this.bgImgTarget.offsetHeight + this.introDivTarget.offsetHeight <= this.element.offsetHeight) {
        this.introDivTarget.classList.remove('absolute');
        this.introDivTarget.classList.add('flex', 'content-center', 'flex-auto');
      } else {
        this.introDivTarget.classList.remove('flex', 'content-center', 'flex-auto');
        this.introDivTarget.classList.add('absolute');
      }
    }
  }

  connect() {
    setTimeout(() => {
      this.resize();
    }, 50);
  }

  layout() {
    setTimeout(() => {
      this.resize();
    }, 50);
  }
}
