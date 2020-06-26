import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    const scrollama_offset = parseFloat(this.data.get("offset"));

    function handleStepEnter(response) {
      const { direction, index } = response;
      if (direction == 'down') {
        if (index === 0) {
          const carousel_controller = web_app.controllers.find(c => c.identifier == 'carousel2');
          if (carousel_controller) {
            carousel_controller.stopAutoPlay();
          }
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

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: document.querySelectorAll('.scroller-step'),
        container: document.documentElement,
        graphic: '.scroll__graphic',
        offset: scrollama_offset,
        threshold: 2,
        order: true,
      })

    scroller
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
