import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ['nav', 'form', 'formInput', 'formSubmit', 'formUnderline', 'formSwitch', 'asideMenu', 'mobileSearch'];
    static values = {
        isActive: Boolean,
        amtTime: Number,
    };

    initialize() {
        this.isActive = this.isActiveValue;
        this.amtTime = this.amtTimeValue;
        this.amtMaxOpacity = 1;
        this.amtMinOpacity = 0;
        this.amtNavOpacity = 1;
        this.amtFormOpacity = 0;
        this.amtMaxLeft = 0;
        this.amtMinLeft = 0;
        this.amtLeft = 0;
        this.animationFrameId = null;
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
        if (this.animationFrameId) cancelAnimationFrame(this.animationFrameId);
        if (this.hasNavTarget && this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (!this.formTarget.classList.contains('show')) this.formTarget.classList.add('show');
            if (this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.remove('opacity-100');
            if (!this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.add('opacity-0');
            let lastT = Date.now();
            let flag = true;
            this.amtMaxLeft = this.formSwitchTarget.offsetLeft - this.formTarget.offsetLeft;
            this.amtLeft = this.amtMaxLeft;
            this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
            const fn = () => {
                const currT = Date.now();
                const diff = currT - lastT;
                lastT = currT;
                const ratio = diff / this.amtTime;
                const perOpacity = (this.amtMaxOpacity - this.amtMinOpacity) * ratio;
                const perLeft = (this.amtMaxLeft - this.amtMinLeft) * ratio;
                this.amtNavOpacity -= perOpacity;
                this.amtFormOpacity += perOpacity;
                this.amtLeft -= perLeft;
                if (this.amtNavOpacity <= this.amtMinOpacity) {
                    flag = false;
                    this.animationFrameId = null;
                    this.amtNavOpacity = this.amtMinOpacity;
                    if (this.navTarget.classList.contains('show')) this.navTarget.classList.remove('show');
                    this.amtFormOpacity = this.amtMaxOpacity;
                    this.amtLeft = this.amtMinLeft;
                }
                this.navTarget.style.opacity = this.amtNavOpacity;
                this.formInputTarget.style.opacity = this.amtFormOpacity;
                this.formUnderlineTarget.style.opacity = this.amtFormOpacity;
                this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
                if (flag) this.animationFrameId = requestAnimationFrame(fn);
            }
            fn();
            this.formInputTarget.focus();
        }
    }

    hideForm = event => {
        if (this.animationFrameId) cancelAnimationFrame(this.animationFrameId);
        if (this.hasNavTarget && this.hasFormTarget && this.hasFormInputTarget && this.hasFormUnderlineTarget && this.hasFormSubmitTarget && this.hasFormSwitchTarget) {
            if (!this.navTarget.classList.contains('show')) this.navTarget.classList.add('show');
            let lastT = Date.now();
            let flag = true;
            const fn = () => {
                const currT = Date.now();
                const diff = currT - lastT;
                lastT = currT;
                const ratio = diff / this.amtTime;
                const perOpacity = (this.amtMaxOpacity - this.amtMinOpacity) * ratio;
                const perLeft = (this.amtMaxLeft - this.amtMinLeft) * ratio;
                this.amtNavOpacity += perOpacity;
                this.amtFormOpacity -= perOpacity;
                this.amtLeft += perLeft;
                if (this.amtNavOpacity >= this.amtMaxOpacity) {
                    flag = false;
                    this.animationFrameId = null;
                    this.amtNavOpacity = this.amtMaxOpacity;
                    this.amtFormOpacity = this.amtMinOpacity;
                    this.amtLeft = this.amtMaxLeft;
                    if (this.formTarget.classList.contains('show')) this.formTarget.classList.remove('show');
                    if (this.formSwitchTarget.classList.contains('opacity-0')) this.formSwitchTarget.classList.remove('opacity-0');
                    if (!this.formSwitchTarget.classList.contains('opacity-100')) this.formSwitchTarget.classList.add('opacity-100');
                }
                this.navTarget.style.opacity = this.amtNavOpacity;
                this.formInputTarget.style.opacity = this.amtFormOpacity;
                this.formUnderlineTarget.style.opacity = this.amtFormOpacity;
                this.formSubmitTarget.style.transform = `translateX(${this.amtLeft}px)`;
                if (flag) this.animationFrameId = requestAnimationFrame(fn);
            };
            fn();
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

    preventDefaultEvent = event => {
        event.preventDefault();
    }
}