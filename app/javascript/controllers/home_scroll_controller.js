import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  static targets = [ "navBar" ]

  connect() {
    // scrollama event handlers
    function handleStepEnter(response) {
      const { direction } = response;
      if (direction == 'down') {
        this.navBarTarget.classList.add("bg-black");
      }
    }

    function handleStepExit(response) {
      // response = { element, direction, index }
      const { direction } = response;
      if (direction == 'up') {
        this.navBarTarget.classList.remove("bg-black");
      }
    }

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step"
      })
      .onStepEnter(handleStepEnter.bind(this))
      .onStepExit(handleStepExit.bind(this));
  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
  }
}
