import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['sliders', 'dots'];

  connect() {
    this.setSlidersSize();
    window.addEventListener('resize', this.setSlidersSize);
  }

  setSlidersSize = () => {
    const footer = document.querySelector('footer');
    const centerHeight = document.documentElement.clientHeight - this.element.offsetTop - footer.offsetHeight;
    if (this.hasSlidersTarget) {
      const parentStyle = getComputedStyle(this.element);
      const parentWidth = this.element.offsetWidth - parseInt(parentStyle['paddingLeft']) - parseInt(parentStyle['paddingRight']);
      const imgWidth = parseInt(this.data.get('img-width'));
      const imgHeight = parseInt(this.data.get('img-height'));
      const slidersWidth = parentWidth > imgWidth ? imgWidth : parentWidth;
      const slidersHeight = imgHeight * slidersWidth / imgWidth;
      const dotsHeight = this.hasDotsTarget ? this.dotsTarget.offsetHeight : 0;
      const centerMinHeight = slidersHeight + dotsHeight + parseInt(parentStyle['paddingTop']) + parseInt(parentStyle['paddingBottom']);
      const parentHeight = centerHeight > centerMinHeight ? centerHeight : centerMinHeight;
      this.element.style.height = `${parentHeight}px`;
      this.slidersTarget.style.width = `${slidersWidth}px`;
      this.slidersTarget.style.height = `${slidersHeight}px`;
    }
  }

  disconnect() {
    window.removeEventListener('resize', this.setSlidersSize);
  }
}