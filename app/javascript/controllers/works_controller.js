import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const navWorksItem = document.getElementById('nav-works-item');
    navWorksItem.classList.add("text-black6c");
  }
}
