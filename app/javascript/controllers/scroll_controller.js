import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    const scrollama_offset = parseFloat(this.data.get("offset"));
    const starting_threshold = parseFloat(this.data.get("threshold"));
    const amplify_rate = parseFloat(this.data.get("amplify_rate"));
    const hide_element_id = this.data.get("hide_element_id");

    function handleStepEnter(response) {
      const { direction, index } = response;
      if (direction == 'down') {
        if (index === 0) {
          const thapeLogo = document.getElementById('thape-nav-logo');
          const thapeNavBar = document.getElementById('thape-nav-bar');
          const thapeNavContainer = document.getElementById('thape-nav-container');

          thapeNavBar.classList.remove("nav-background-initial");
          thapeNavBar.classList.add("nav-background-white");
          thapeNavBar.classList.add("border-gray-200");
          thapeNavBar.classList.add("border-solid");
          thapeNavBar.classList.add("border-b");
          const tc = thapeLogo.classList;
          tc.add("text-black6c");
          tc.remove("text-thape-white-t80");
          tc.add("hover:text-black6c-t70");
          tc.add("focus:text-black6c-t70");
          tc.remove("hover:text-white");
          tc.remove("focus:text-white");

          for (let a of thapeNavContainer.children) {
            const c=a.classList;
            c.add("hover:text-black6c");
            c.add("focus:text-black6c");
            c.remove("hover:text-white");
            c.remove("focus:text-white");
          }
          thapeNavContainer.classList.remove("text-thape-white-t80");
          thapeNavContainer.classList.add("text-thape-copyright-gray");
          if(hide_element_id) {
            document.getElementById(hide_element_id).classList.add("hidden");
          }
        } else if (index === 1) {
          const thapeProjects = document.getElementById('thape-fadein');
          thapeProjects.style.opacity = 1;
        }
      }
    }

    function handleStepExit(response) {
      const { direction, index } = response;
      if (direction == 'up') {
        if (index === 0) {
          const thapeLogo = document.getElementById('thape-nav-logo');
          const thapeNavBar = document.getElementById('thape-nav-bar');
          const thapeNavContainer = document.getElementById('thape-nav-container');

          thapeNavContainer.classList.remove("text-thape-copyright-gray");
          thapeNavContainer.classList.add("text-thape-white-t80");
          for (let a of thapeNavContainer.children) {
            const c=a.classList;
            c.remove("hover:text-black6c");
            c.remove("focus:text-black6c");
            c.add("hover:text-white");
            c.add("focus:text-white");
          }
          const tc = thapeLogo.classList;
          tc.add("text-thape-white-t80");
          tc.remove("text-black6c");
          tc.remove("hover:text-black6c-t70");
          tc.remove("focus:text-black6c-t70");
          tc.add("hover:text-white");
          tc.add("focus:text-white");
          thapeNavBar.classList.remove("nav-background-white");
          thapeNavBar.classList.remove("border-gray-200");
          thapeNavBar.classList.remove("border-solid");
          thapeNavBar.classList.remove("border-b");
          thapeNavBar.classList.add("nav-background-initial");
          if(hide_element_id) {
            document.getElementById(hide_element_id).classList.remove("hidden");
          }
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
        order: false,
      })
      .onStepProgress(handleStepProgress)
      .onStepEnter(handleStepEnter)
      .onStepExit(handleStepExit);

    scroller.resize();
  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
  }
}
