import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    const scrollama_offset = parseFloat(this.data.get("offset"));
    const amplify_rate = parseFloat(this.data.get("amplify_rate"));

    function handleStepEnter(response) {
      const { direction, index } = response;
      if (direction == 'down') {
        if (index === 0) {
          const carousel_controller = web_app.controllers.find(c => c.identifier == 'carousel2');
          if (carousel_controller) {
            carousel_controller.stopAutoPlay();
          }
        }
        else if (index === 1) {
          const thapeFadein = document.getElementById('thape-new-projects');
          thapeFadein.style.opacity = 1;
        }
      }
    }

    function handleStepExit(response) {
      const { direction, index } = response;
      if (direction == 'up') {
        if (index === 0) {
          const carousel_controller = web_app.controllers.find(c => c.identifier == 'carousel2');
          if (carousel_controller) {
            carousel_controller.startAutoPlay();
          }
        }
      }
    }

    function handleStepProgress(response) {
      const { element, progress, index } = response;

      const eo = progress <= 0 ? 0.001 : progress * amplify_rate;
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
        step: document.querySelectorAll('.scroller-step'),
        offset: scrollama_offset,
        threshold: 2,
        progress: true,
        order: true,
      })

    scroller
      .onStepProgress(handleStepProgress)
      .onStepEnter(handleStepEnter)
      .onStepExit(handleStepExit);

    setTimeout(() => {
      scroller.resize();
    }, 200)
  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
  }
}
