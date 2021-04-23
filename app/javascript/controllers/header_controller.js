import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ['nav', 'form', 'formInput', 'formSubmit', 'formUnderline', 'formSwitch', 'asideMenu', 'mobileSearch'];

    initialize() {
        this.isActive = this.data.get('isActive') === 'true';
        this.amtTime = Number(this.data.get('amtTime'));
        this.amtFreq = Number(this.data.get('amtFreq'));
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

    amtTimer = null
    amtMaxOpacity = 1
    amtMinOpacity = 0
    amtNavOpacity = 1
    amtFormOpacity = 0
    amtMaxLeft = 0
    amtMinLeft = 0
    amtLeft = 0

    showForm = event => {
        const perOpacity = this.amtMaxOpacity / this.amtFreq;
        const perTime = this.amtTime / this.amtFreq;
        if (this.hasNavTarget && this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (this.amtTimer) clearInterval(this.amtTimer);
            if (!this.formTarget.classList.contains('show')) this.formTarget.classList.add('show');
            if (this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.remove('opacity-100');
            if (!this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.add('opacity-0');
            this.amtMaxLeft = this.formSwitchTarget.offsetLeft - this.formTarget.offsetLeft;
            const perLeft = this.amtMaxLeft / this.amtFreq;
            this.amtLeft = this.amtMaxLeft;
            this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
            this.amtTimer = setInterval(() => {
                this.amtNavOpacity -= perOpacity;
                this.amtFormOpacity += perOpacity;
                this.amtLeft -= perLeft;
                if (this.amtNavOpacity <= this.amtMinOpacity) {
                    this.amtNavOpacity = this.amtMinOpacity;
                    if (this.navTarget.classList.contains('show')) this.navTarget.classList.remove('show');
                    this.amtFormOpacity = this.amtMaxOpacity;
                    this.amtLeft = this.amtMinLeft;
                    clearInterval(this.amtTimer);
                    this.amtTimer = null;
                }
                requestAnimationFrame(() => {
                    this.navTarget.style.opacity = this.amtNavOpacity;
                    this.formInputTarget.style.opacity = this.amtFormOpacity;
                    this.formUnderlineTarget.style.opacity = this.amtFormOpacity;
                    this.formSubmitTarget.style.transition = `transform ease ${perTime / this.amtTime}s`;
                    this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
                });
            }, perTime);
            this.formInputTarget.focus();
        }
    }

    hideForm = event => {
        const perOpacity = this.amtMaxOpacity / this.amtFreq;
        const perTime = this.amtTime / this.amtFreq;
        if (this.hasNavTarget && this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (this.amtTimer) clearInterval(this.amtTimer);
            if (!this.navTarget.classList.contains('show')) this.navTarget.classList.add('show');
            const perLeft = this.amtMaxLeft / this.amtFreq;
            this.amtTimer = setInterval(() => {
                this.amtNavOpacity += perOpacity;
                this.amtFormOpacity -= perOpacity;
                this.amtLeft += perLeft;
                if (this.amtNavOpacity >= this.amtMaxOpacity) {
                    this.amtNavOpacity = this.amtMaxOpacity;
                    this.amtFormOpacity = this.amtMinOpacity;
                    this.amtLeft = this.amtMaxLeft;
                    if (this.formTarget.classList.contains('show')) this.formTarget.classList.remove('show');
                    if (this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.remove('opacity-0');
                    if (!this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.add('opacity-100');
                    clearInterval(this.amtTimer);
                    this.amtTimer = null;
                }
                requestAnimationFrame(() => {
                    this.navTarget.style.opacity = this.amtNavOpacity;
                    this.formInputTarget.style.opacity = this.amtFormOpacity;
                    this.formUnderlineTarget.style.opacity = this.amtFormOpacity;
                    this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
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