import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ['nav', 'form', 'formInput', 'asideMenu', 'mobileSearch'];

    initialize() {
        this.isActive = this.data.get('isActive') === 'true';
    }

    connect() {
        if (!this.isActive) {
            document.addEventListener('scroll', this.setHeaderActive);
        }
    }

    disconnect() {
        if (!this.isActive) {
            document.removeEventListener('scroll', this.setHeaderActive);
        }
    }

    setHeaderActive = () => {
        const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
        if (scrollTop > 200) this.element.classList.add('active');
        else this.element.classList.remove('active');
    }

    // 手机端菜单栏切换显隐
    toggleAsideMenu = event => {
        const e = event || window.event;
        e.preventDefault();
        if (this.hasAsideMenuTarget) {
            this.asideMenuTarget.style.display === 'none' ? this.showAsideMenu() : this.hideAsideMenu();
        }
    }

    showAsideMenu = event => {
        if (this.hasAsideMenuTarget) {
            this.asideMenuTarget.style.display = 'block';
        }
        this.hideMobileSearch();
    }

    hideAsideMenu = event => {
        if (this.hasAsideMenuTarget) {
            this.asideMenuTarget.style.display = 'none';
        }
    }

    showForm = event => {
        console.log(123123, this.hasNavTarget)
        if (this.hasNavTarget) {
            this.navTarget.style.display = 'none';
        }
        if (this.hasFormTarget) {
            this.formTarget.style.display = 'flex';
        }
        if (this.hasFormInputTarget) {
            this.formInputTarget.focus();
        }
    }

    hideForm = event => {
        if (this.hasNavTarget) {
            this.navTarget.style.display = 'flex';
        }
        if (this.hasFormTarget) {
            this.formTarget.style.display = 'none';
        }
    }

    showMobileSearch = event => {
        if (this.hasMobileSearchTarget) {
            this.mobileSearchTarget.style.display = 'block';
        }
        this.hideAsideMenu();
    }

    hideMobileSearch = event => {
        if (this.hasMobileSearchTarget) {
            this.mobileSearchTarget.style.display = 'none';
        }
    }

    menuItemClick = (event) => {
        const e = event || window.event;
        e.stopPropagation();
        if (e.target.tagName.toLowerCase() === 'a') {
            const parent = e.target.parentElement;
            if (parent) {
                const asideMenuChildren = parent.querySelector('.aside-menu-children');
                if (asideMenuChildren) {
                    e.preventDefault && e.preventDefault();
                    const display = asideMenuChildren.style.display;
                    asideMenuChildren.style.display = display === 'none' ? 'block' : 'none';
                }
            }
        }
    }
}