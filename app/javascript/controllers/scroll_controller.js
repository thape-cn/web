import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    const nav_id_name = this.data.get("nav_active_item");
    const scrollama_offset = parseFloat(this.data.get("offset"));
    const starting_threshold = parseFloat(this.data.get("threshold"));

    function handleStepEnter(response) {
      const { direction, index } = response;
      const navWorksItem = document.getElementById(nav_id_name);
      if (direction == 'down') {
        if (index === 0) {
          nav_menu.turnWhite();
          navWorksItem.classList.add("text-black6c");
        } else if (index === 1) {
          nav_menu.turnWhite();
          navWorksItem.classList.add("text-black6c");
        }
      }
    }

    function handleStepExit(response) {
      const { direction, index } = response;
      const navWorksItem = document.getElementById(nav_id_name);
      if (direction == 'up') {
        if (index === 0) {
          navWorksItem.classList.remove("text-black6c");
          nav_menu.turnTransparent();
        } else if (index === 1) {
          navWorksItem.classList.remove("text-black6c");
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
