import "intersection-observer";
import scrollama from "scrollama";
import { Controller } from "stimulus"

const scroller = scrollama();

export default class extends Controller {
  connect() {
    function handleStepEnter(response) {
      const { element, direction, index } = response;
      if (direction == 'down') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavBar = document.getElementById('thape-nav-bar');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        if (element.id == 'thape-projects') {
          thapeNavBar.classList.remove("nav-background-initial");
          thapeNavBar.classList.add("nav-background-white");
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
        } else if (element.id === 'thape-news') {
          const project = document.getElementById('thape-projects');
          project.classList.remove("sticky");
          project.classList.remove("top-0");
        } else if (element.id === 'thape-form') {
          const news = document.getElementById('thape-news');
          news.classList.remove("sticky");
          news.classList.remove("top-0");
        }
      }
    }

    function handleStepExit(response) {
      const { element, direction, index } = response;
      if (direction == 'up') {
        const thapeLogo = document.getElementById('thape-nav-logo');
        const thapeNavBar = document.getElementById('thape-nav-bar');
        const thapeNavContainer = document.getElementById('thape-nav-container');

        if (element.id == 'thape-projects') {
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
          thapeNavBar.classList.add("nav-background-initial");
        } else if (element.id === 'thape-news') {
          const project = document.getElementById('thape-projects');
          project.classList.add("sticky");
          project.classList.add("top-0");
        } else if (element.id === 'thape-form') {
          const news = document.getElementById('thape-news');
          news.classList.add("sticky");
          news.classList.add("top-0");
        }
      }
    }

    function handleStepProgress(response) {
      const { element, progress, index } = response;
      const debugProgress = document.getElementById('debug-progress');
      debugProgress.innerHTML = element.id + ' ' + progress;

      const eo = ((progress - 0.40) <= 0 ? 0 : progress - 0.40) * 2.2;
      if (element.id === 'thape-projects') {
        if (eo >= 1) {
          element.style.opacity = 1;
          element.classList.add("sticky");
          element.classList.add("top-0");
        } else {
          element.style.opacity = eo;
          element.classList.remove("sticky");
          element.classList.remove("top-0");
        }
      } else if (element.id === 'thape-news') {
        const project = document.getElementById('thape-projects');
        project.classList.remove("sticky");
        project.classList.remove("top-0");
      } else if (element.id === 'thape-form') {
        const news = document.getElementById('thape-news');
        news.classList.remove("sticky");
        news.classList.remove("top-0");
      }
    }

    // setup the instance, pass callback functions
    scroller
      .setup({
        step: ".scroller-step",
        offset: 0.95,
        progress: true,
        debug: true
      })
      .onStepEnter(handleStepEnter)
      .onStepExit(handleStepExit)
      .onStepProgress(handleStepProgress);;

    scroller.resize();
  }

  layout() {
    scroller.resize();
  }

  disconnect() {
    scroller.destroy();
  }
}
