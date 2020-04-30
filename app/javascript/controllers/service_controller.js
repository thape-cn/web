import "intersection-observer";
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

          const serviceSection = document.getElementById('service-section');
          const serviceIntro = document.getElementById('service-intro');
          serviceSection.classList.remove("h-screen");
          serviceIntro.classList.remove("absolute");
          serviceIntro.classList.remove("bottom-0");
          serviceIntro.classList.remove("inset-x-0");
          serviceIntro.classList.remove("opacity-75");
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

          const serviceSection = document.getElementById('service-section');
          const serviceIntro = document.getElementById('service-intro');
          serviceSection.classList.add("h-screen");
          serviceIntro.classList.add("absolute");
          serviceIntro.classList.add("bottom-0");
          serviceIntro.classList.add("inset-x-0");
          serviceIntro.classList.add("opacity-75");
        }
      }
    }

    scroller
      .setup({
        step: ".scroller-step",
        offset: scrollama_offset,
        threshold: 2,
        progress: true,
        order: true,
      })

    scroller
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
