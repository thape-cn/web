import WorkCarouselController from "./work_carousel_controller"

export default class extends WorkCarouselController {
  connect() {
    this.manuallyPaused = false
    super.connect()
  }

  syncPlayback() {
    super.syncPlayback()
    if (this.suspended) this.clearTimer()
    if (this.hasRotationTarget) this.rotationTarget.hidden = !this.manuallyPaused
  }

  manualMove(direction) {
    this.manuallyPaused = true
    this.lastArrow = this.element.querySelector(direction < 0 ? ".action-left" : ".action-right")
    super.manualMove(direction)
  }

  resume() {
    if (this.rotationTarget.contains(document.activeElement)) this.lastArrow?.focus({ preventScroll: true })
    this.manuallyPaused = false
    this.paused = false
    // Explicit resume takes effect even while the pointer remains over the carousel.
    this.hovered = false
    this.syncPlayback()
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
