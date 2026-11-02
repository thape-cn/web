import WorkCarouselController from "./work_carousel_controller"

export default class extends WorkCarouselController {
  syncPlayback() {
    super.syncPlayback()
    if (this.suspended) this.clearTimer()
  }

  stopAutoPlay() {
    this.suspended = true
    this.syncPlayback()
  }

  startAutoPlay() {
    this.suspended = false
    this.syncPlayback()
  }

  showCurrent() {
    super.showCurrent()
    this.slideTargets.forEach((slide, index) => {
      slide.inert = index !== this.index
    })
    this.element.dispatchEvent(
      new CustomEvent("home-carousel:change", { bubbles: true, detail: { slide: this.slideTargets[this.index] } }),
    )
  }

  resize() {
    // Homepage slides fill the viewport instead of following the image aspect ratio.
  }
}
