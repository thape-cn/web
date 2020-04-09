import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  static targets = [ "navBar" ];

  connect() {
    // scrollama event handlers
    function handleStepEnter(response) {
      const { element, direction } = response;
      if (direction == 'down') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        if (element.id == 'thape-new-projects') {
          this.navBarTarget.classList.remove("nav-background-initial");
          this.navBarTarget.classList.add("nav-background-white");
          thapeLogo.classList.remove("text-white");
          thapeNavContainer.classList.remove("text-white");
          thapeNavContainer.classList.add("text-black");
        }
      }
    }

    function handleStepExit(response) {
      // response = { element, direction, index }
      const { element, direction } = response;
      if (direction == 'up') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        if (element.id == 'thape-new-projects') {
          thapeNavContainer.classList.remove("text-black");
          thapeNavContainer.classList.add("text-white");
          thapeLogo.classList.add("text-white");
          this.navBarTarget.classList.remove("nav-background-white");
          this.navBarTarget.classList.add("nav-background-initial");
        }
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
