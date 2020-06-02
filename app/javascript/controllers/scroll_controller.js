import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
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

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step",
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
