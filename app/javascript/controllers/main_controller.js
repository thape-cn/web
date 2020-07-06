import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ['footer', 'footerLine'];

    connect() {
        this.setHeight();
        window.addEventListener('resize', this.setHeight);
    }

    setHeight = () => {
        this.element.style.height = `calc(100vh - ${this.element.offsetTop}px)`;
        
        if (this.hasFooterTarget && this.hasFooterLineTarget) {
            if (this.footerTarget.offsetTop > this.footerLineTarget.offsetTop) {
                if (this.footerTarget.offsetTop + this.footerTarget.offsetHeight < this.element.offsetHeight) {
                    this.footerTarget.style.position = 'absolute';
                    this.footerTarget.style.bottom = '0px';
                }
            } else {
                this.footerTarget.style.position = 'relative';
                this.footerTarget.style.top = 'auto';
            }
        }
    }

    disconnect() {
        window.removeEventListener('resize', this.setHeight);
    }
}