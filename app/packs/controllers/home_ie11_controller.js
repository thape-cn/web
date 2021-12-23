import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const Waypoint = window.Waypoint;
    for (let i = 0; i < 10; i++) {
      new Waypoint({
        element: document.getElementById('thape-home-waypoint'),
        handler: function(direction) {
          this.element.style.opacity = direction === 'down' ? 0.1 * i + 0.1 : 0.1 * i;
        },
        offset: `${100 - i * 5}%`,
      });
    }
  }

  layout() {
  }
}
