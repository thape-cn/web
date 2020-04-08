import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  static targets = [ "navBar" ];

  connect() {
    // scrollama event handlers
    function handleStepEnter(response) {
      const { direction } = response;
      if (direction == 'down') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        this.navBarTarget.classList.add("nav-background-color");
        thapeLogo.classList.remove("text-white");
        thapeNavContainer.classList.remove("text-white");
        thapeNavContainer.classList.add("text-black");
      }
    }

    function handleStepExit(response) {
      // response = { element, direction, index }
      const { direction } = response;
      if (direction == 'up') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        thapeNavContainer.classList.remove("text-black");
        thapeNavContainer.classList.add("text-white");
        thapeLogo.classList.add("text-white");
        this.navBarTarget.classList.remove("nav-background-color");
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
