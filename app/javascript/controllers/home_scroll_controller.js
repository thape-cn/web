import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    this.outputTarget.textContent = 'Hello, Stimulus!'

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step"
      })
      .onStepEnter(response => {
        console.log(response);
      })
      .onStepExit(response => {
        console.log(response);
      });
  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
  }
}
