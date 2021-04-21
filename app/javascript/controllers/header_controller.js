import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ['nav', 'form', 'formInput', 'formSubmit', 'formUnderline', 'formSwitch', 'asideMenu', 'mobileSearch'];

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

    navTimer = null
    navOpacity = 1
    formTimer = null
    formOpacity = 0
    totalTime = 500
    freq = 15
    distance = 0
    iconLeft = 0

    showForm = event => {
        const perOpacity = 1 / this.freq;
        const perTime = this.totalTime / this.freq;
        if (this.hasNavTarget) {
            if (this.navTimer) clearInterval(this.navTimer);
            this.navTimer = setInterval(() => {
                this.navOpacity -= perOpacity;
                if (this.navOpacity <= 0) {
                    this.navOpacity = 0;
                    clearInterval(this.navTimer);
                    this.navTimer = null;
                    if (this.navTarget.classList.contains('show')) this.navTarget.classList.remove('show');
                }
                requestAnimationFrame(() => {
                    this.navTarget.style.opacity = this.navOpacity;
                });
            }, perTime);
        }
        if (this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (this.formTimer) clearInterval(this.formTimer);
            if (!this.formTarget.classList.contains('show')) this.formTarget.classList.add('show');
            if (this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.remove('opacity-100');
            if (!this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.add('opacity-0');
            this.distance = this.formSwitchTarget.offsetLeft - this.formTarget.offsetLeft;
            this.iconLeft = this.distance;
            const perLeft = this.distance / this.freq;
            this.formSubmitTarget.style.transition = `transform ease ${perTime / this.totalTime}s`;
            this.formTimer = setInterval(() => {
                this.formOpacity += perOpacity;
                this.iconLeft -= perLeft;
                if (this.formOpacity >= 1) {
                    this.formOpacity = 1;
                    clearInterval(this.formTimer);
                    this.formTimer = null;
                }
                if (this.iconLeft < 0) this.iconLeft = 0;
                requestAnimationFrame(() => {
                    this.formInputTarget.style.opacity = this.formOpacity;
                    this.formUnderlineTarget.style.opacity = this.formOpacity;
                    this.formSubmitTarget.style.transform = `translateX(${this.iconLeft}px)`;
                });
            }, perTime);
        }
        if (this.hasFormInputTarget) {
            this.formInputTarget.focus();
        }
    }

    hideForm = event => {
        const perOpacity = 1 / this.freq;
        const perTime = this.totalTime / this.freq;
        if (this.hasNavTarget) {
            if (this.navTimer) clearInterval(this.navTimer);
            if (!this.navTarget.classList.contains('show')) this.navTarget.classList.add('show');
            this.navTimer = setInterval(() => {
                this.navOpacity += perOpacity;
                if (this.navOpacity >= 1) {
                    this.navOpacity = 1;
                    clearInterval(this.navTimer);
                    this.navTimer = null;
                }
                requestAnimationFrame(() => {
                    this.navTarget.style.opacity = this.navOpacity;
                });
            }, perTime);
        }
        if (this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (this.formTimer) clearInterval(this.formTimer);
            const perLeft = this.distance / this.freq;
            this.formTimer = setInterval(() => {
                this.formOpacity -= perOpacity;
                this.iconLeft += perLeft;
                if (this.formOpacity <= 0) {
                    this.formOpacity = 0;
                    clearInterval(this.formTimer);
                    this.formTimer = null;
                    if (this.formTarget.classList.contains('show')) this.formTarget.classList.remove('show');
                    if (this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.remove('opacity-0');
                    if (!this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.add('opacity-100');
                }
                if (this.iconLeft > this.distance) this.iconLeft = this.distance;
                requestAnimationFrame(() => {
                    this.formInputTarget.style.opacity = this.formOpacity;
                    this.formUnderlineTarget.style.opacity = this.formOpacity;
                    this.formSubmitTarget.style.transform = `translateX(${this.iconLeft}px)`;
                });
            }, perTime);
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