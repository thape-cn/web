import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    const scrollama_offset = parseFloat(this.data.get("offset"));
    const starting_threshold = parseFloat(this.data.get("threshold"));

    function handleStepEnter(response) {
      const { direction, index } = response;
      if (direction == 'down') {
        if (index === 0) {
          const carousel_controller = web_app.controllers.find(c => c.identifier == 'carousel');
          if (carousel_controller) {
            carousel_controller.stop_rotate();
          }
        }
      }
    }

    function handleStepExit(response) {
      const { direction, index } = response;
      if (direction == 'up') {
        if (index === 0) {
          const carousel_controller = web_app.controllers.find(c => c.identifier == 'carousel');
          if (carousel_controller) {
            carousel_controller.start_rotate();
          }
        }
      }
    }

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step",
        offset: scrollama_offset,
        threshold: 2,
        order: true,
        container: document.querySelector('#scroll-scroller-div')
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
