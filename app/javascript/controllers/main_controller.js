import { Controller } from "stimulus";

export default class extends Controller {
    connect() {
        this.setHeight();
        window.addEventListener('resize', this.setHeight);
    }

    setHeight = () => {
        this.element.style.height = `calc(100vh - ${this.element.offsetTop}px)`;
    }

    disconnect() {
        window.removeEventListener('resize', this.setHeight);
    }
}