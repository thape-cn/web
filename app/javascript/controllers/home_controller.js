import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  static targets = [ "nextSlide" ]

  connect() {
    const scrollama_offset = parseFloat(this.data.get("offset"));
    const starting_threshold = parseFloat(this.data.get("threshold"));
    const amplify_rate = parseFloat(this.data.get("amplify_rate"));

    function handleStepEnter(response) {
      const { direction, index } = response;
      if (direction == 'down') {
        if (index === 0) {
          nav_menu.turnWhite();
        } else if (index === 1) {
          nav_menu.turnWhite();
          const thapeFadein = document.getElementById('thape-fadein');
          if(thapeFadein) {
            thapeFadein.style.opacity = 1;
          }
        }
      }
    }

    function handleStepExit(response) {
      const { direction, index } = response;
      if (direction == 'up') {
        if (index === 0) {
          nav_menu.turnTransparent();
        } else if (index === 1) {
          nav_menu.turnTransparent();
        }
      }
    }

    function handleStepProgress(response) {
      const { element, progress, index } = response;
      const debugProgress = document.getElementById('debug-progress');
      if (debugProgress)
        debugProgress.innerHTML = element.id + ' ' + progress;

      const eo = ((progress - starting_threshold) <= 0 ? 0.001 : progress - starting_threshold) * amplify_rate;
      if (index === 0) {
        if (eo >= 1) {
          element.style.opacity = 1;
        } else {
          element.style.opacity = eo;
        }
      }
    }

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step",
        offset: scrollama_offset,
        threshold: 2,
        progress: true,
        order: true,
      })

    scroller
      .onStepProgress(handleStepProgress)
      .onStepEnter(handleStepEnter)
      .onStepExit(handleStepExit);


    if (this.data.has("refreshInterval")) {
      this.start_rotate()
    }

    setTimeout(() => {
      scroller.resize();
    }, 200)

  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
    this.stop_rotate();
  }

  start_rotate() {
    this.refreshTimer = setInterval(() => {
      this.nextSlideTarget.click();
    }, this.data.get("refreshInterval"))
  }

  stop_rotate() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
