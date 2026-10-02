import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["slide", "images", "rotation", "pauseLabel", "playLabel", "status"];
  static values = { interval: Number };

  connect() {
    this.index = 0;
    this.motion = window.matchMedia("(prefers-reduced-motion: reduce)");
    this.paused = this.motion.matches;
    this.hovered = false;
    this.transitioning = false;
    this.motion.addEventListener("change", this.motionChanged);
    document.addEventListener("visibilitychange", this.visibilityChanged);
    this.showCurrent();
    this.syncPlayback();
    this.resize();
  }

  disconnect() {
    this.clearTimer();
    clearTimeout(this.transitionTimer);
    this.motion.removeEventListener("change", this.motionChanged);
    document.removeEventListener("visibilitychange", this.visibilityChanged);
  }

  clearTimer() {
    clearInterval(this.timer);
    this.timer = null;
  }

  syncPlayback() {
    this.clearTimer();
    if (!this.paused && !this.hovered && !document.hidden && this.slideTargets.length > 1) {
      this.timer = setInterval(() => this.move(1), this.intervalValue || 5000);
    }
    if (this.hasRotationTarget) {
      this.pauseLabelTarget.hidden = this.paused;
      this.playLabelTarget.hidden = !this.paused;
      this.statusTarget.setAttribute("aria-live", this.paused ? "polite" : "off");
    }
  }

  rememberPlayback() {
    this.pointerPaused = this.paused;
  }

  togglePlayback(event) {
    const paused = event.detail > 0 ? (this.pointerPaused ?? this.paused) : this.paused;
    this.pointerPaused = null;
    this.paused = !paused;
    this.syncPlayback();
  }

  pauseOnFocus() {
    // Focus pauses rotation until the visitor explicitly resumes it.
    this.paused = true;
    this.syncPlayback();
  }

  pointerEnter(event) {
    if (event.pointerType !== "mouse" || !window.matchMedia("(hover: hover)").matches) return;
    this.hovered = true;
    this.syncPlayback();
  }

  pointerLeave(event) {
    if (event.pointerType !== "mouse") return;
    this.hovered = false;
    this.syncPlayback();
  }

  motionChanged = () => {
    if (this.motion.matches) {
      this.paused = true;
      this.finishTransition();
    }
    this.syncPlayback();
  };

  visibilityChanged = () => this.syncPlayback();

  previous() {
    this.manualMove(-1);
  }

  next() {
    this.manualMove(1);
  }

  manualMove(direction) {
    this.paused = true;
    this.syncPlayback();
    this.move(direction);
  }

  move(direction) {
    if (this.transitioning || this.slideTargets.length < 2) return;
    const previous = this.slideTargets[this.index];
    this.index = (this.index + direction + this.slideTargets.length) % this.slideTargets.length;
    this.showCurrent();
    if (!this.motion.matches) {
      this.transitioning = true;
      previous.classList.add("active", "animate", "fade-out");
      this.slideTargets[this.index].classList.add("animate", "fade-in");
      this.transitionTimer = setTimeout(() => this.finishTransition(), 500);
    }
  }

  finishTransition() {
    clearTimeout(this.transitionTimer);
    this.transitioning = false;
    this.showCurrent();
  }

  showCurrent() {
    this.slideTargets.forEach((slide, index) => {
      slide.classList.remove("animate", "fade-in", "fade-out");
      slide.classList.toggle("active", index === this.index);
      slide.setAttribute("aria-hidden", String(index !== this.index));
    });
    if (this.hasStatusTarget) this.statusTarget.textContent = `${this.index + 1} / ${this.slideTargets.length}`;
  }

  resize() {
    const image = this.slideTargets[0]?.querySelector("img");
    if (image?.naturalWidth) this.imagesTarget.style.paddingTop = `${image.naturalHeight / image.naturalWidth * 100}%`;
  }
}
