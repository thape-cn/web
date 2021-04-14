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
            this.asideMenuTarget.classList.contains('show') ? this.hideAsideMenu() : this.showAsideMenu();
        }
    }

    showAsideMenu = event => {
        if (this.hasAsideMenuTarget) {
            if (!this.asideMenuTarget.classList.contains('show')) this.asideMenuTarget.classList.add('show');
        }
        this.hideMobileSearch();
    }

    hideAsideMenu = event => {
        if (this.hasAsideMenuTarget) {
            if (this.asideMenuTarget.classList.contains('show')) this.asideMenuTarget.classList.remove('show');
        }
    }

    showForm = event => {
        if (this.hasNavTarget) {
            if (this.navTarget.classList.contains('show')) this.navTarget.classList.remove('show');
        }
        if (this.hasFormTarget) {
            if (!this.formTarget.classList.contains('show')) this.formTarget.classList.add('show');
        }
        if (this.hasFormInputTarget) {
            this.formInputTarget.focus();
        }
    }

    hideForm = event => {
        if (this.hasNavTarget) {
            if (!this.navTarget.classList.contains('show')) this.navTarget.classList.add('show');
        }
        if (this.hasFormTarget) {
            if (this.formTarget.classList.contains('show')) this.formTarget.classList.remove('show');
        }
    }

    showMobileSearch = event => {
        if (this.hasMobileSearchTarget) {
            if (!this.mobileSearchTarget.classList.contains('show')) this.mobileSearchTarget.classList.add('show');
        }
        this.hideAsideMenu();
    }

    hideMobileSearch = event => {
        if (this.hasMobileSearchTarget) {
            if (this.mobileSearchTarget.classList.contains('show')) this.mobileSearchTarget.classList.remove('show');
        }
    }

    menuItemClick = event => {
        const e = event || window.event;
        e.stopPropagation();
        if (e.target.tagName.toLowerCase() === 'a') {
            const parent = e.target.parentElement;
            if (parent) {
                const asideMenuChildren = parent.querySelector('.aside-menu-children');
                if (asideMenuChildren) {
                    asideMenuChildren.classList.contains('hidden') ? asideMenuChildren.classList.remove('hidden') : asideMenuChildren.classList.add('hidden');
                }
            }
        }
    }
}