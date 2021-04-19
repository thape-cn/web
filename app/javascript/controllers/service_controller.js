import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "bgImg", "introDiv" ]

  connect() {
    this.resize();
  }

  resize() {
    if (this.hasBgImgTarget) {
      const imgWidth = parseInt(this.data.get('imgWidth'));
      const imgHeight = parseInt(this.data.get('imgHeight'));
      const parentStyle = getComputedStyle(this.bgImgTarget);
      const parentWidth = this.bgImgTarget.offsetWidth - parseInt(parentStyle['paddingLeft']) - parseInt(parentStyle['paddingRight']);
      const parentHeight = imgHeight * parentWidth / imgWidth;
      const serviceStyle = getComputedStyle(this.bgImgTarget);
      const serviceHeight = this.element.offsetHeight - parseInt(serviceStyle['paddingLeft']) - parseInt(serviceStyle['paddingRight']);
      const height = parentHeight > serviceHeight ? serviceHeight : parentHeight;
      this.bgImgTarget.style.height = `${height}px`;
      if (height >= this.element.offsetHeight) {
        this.introDivTarget.classList.add("bg-thape-white-t80", 'lg:absolute');
        this.introDivTarget.classList.remove("bg-white", 'flex', 'content-center', 'flex-auto');
      } else {
        this.introDivTarget.classList.remove("bg-thape-white-t80");
        this.introDivTarget.classList.add("bg-white");
        if (height + this.introDivTarget.offsetHeight <= this.element.offsetHeight) {
          this.introDivTarget.classList.remove('lg:absolute');
          this.introDivTarget.classList.add('flex', 'content-center', 'flex-auto');
        } else {
          this.introDivTarget.classList.remove('flex', 'content-center', 'flex-auto');
          this.introDivTarget.classList.add('lg:absolute');
        }
      }
    }
  }
}
