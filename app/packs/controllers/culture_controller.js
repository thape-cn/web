import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['sliders', 'dots', 'slide', 'dot'];
  static values = {
    imgWidth: Number,
    imgHeight: Number,
  };

  connect() {
    this.currentSlide = 0;
    this.render();
    this.scheduleNext(5000);
    this.setSlidersSize();
    window.addEventListener('resize', this.setSlidersSize);
  }

  select(event) {
    this.currentSlide = Number(event.currentTarget.dataset.slide);
    this.render();
    this.scheduleNext(6000);
  }

  scheduleNext(delay) {
    clearTimeout(this.autoplayTimer);
    if (this.slideTargets.length < 2) return;
    this.autoplayTimer = setTimeout(() => {
      this.currentSlide = (this.currentSlide + 1) % this.slideTargets.length;
      this.render();
      this.scheduleNext(6000);
    }, delay);
  }

  render() {
    this.slideTargets.forEach((slide, index) => {
      const active = index === this.currentSlide;
      slide.classList.toggle('culture-slide-active', active);
      slide.setAttribute('aria-hidden', String(!active));
    });
    this.dotTargets.forEach((dot, index) => {
      const active = index === this.currentSlide;
      dot.classList.toggle('bg-gray-500', active);
      dot.classList.toggle('bg-gray-200', !active);
      dot.setAttribute('aria-pressed', String(active));
    });
  }

  setSlidersSize = () => {
    const footer = document.querySelector('footer');
    const centerHeight = document.documentElement.clientHeight - this.element.offsetTop - footer.offsetHeight;
    if (this.hasSlidersTarget) {
      const parentStyle = getComputedStyle(this.element);
      const parentWidth = this.element.offsetWidth - parseInt(parentStyle['paddingLeft']) - parseInt(parentStyle['paddingRight']);
      const imgWidth = this.imgWidthValue;
      const imgHeight = this.imgHeightValue;
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
    clearTimeout(this.autoplayTimer);
    window.removeEventListener('resize', this.setSlidersSize);
  }
}
