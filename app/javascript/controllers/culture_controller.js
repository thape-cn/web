import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['slider'];

  connect() {
    this.setSliderSize();
    window.addEventListener('resize', this.setSliderSize);
  }

  setSliderSize = () => {
    if (this.hasSliderTarget) {
      const style = getComputedStyle(this.element);
      const parentWidth = this.element.offsetWidth - parseInt(style['paddingLeft']) - parseInt(style['paddingRight']);
      const imgWidth = parseInt(this.data.get('img-width'));
      const imgHeight = parseInt(this.data.get('img-height'));
      const width = parentWidth > imgWidth ? imgWidth : parentWidth;
      const height = imgHeight * width / imgWidth;
      this.sliderTarget.style.width = `${width}px`;
      this.sliderTarget.style.height = `${height}px`;
    }
  }

  disconnect() {
    window.removeEventListener('resize', this.setSliderSize);
  }
}