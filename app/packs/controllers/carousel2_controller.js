import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    itemDataType: String,
    activeClass: String,
    animationClassBase: String,
    animationClassLeftIn: String,
    animationClassLeftOut: String,
    animationClassRightIn: String,
    animationClassRightOut: String,
    animationDuration: Number,
    intervalTime: Number,
  }

  initialize() {
    this.inAnimation = false; // 动画是否正在进行中
    this.autoPlayIntervalNum = null; // 动画自动播放的setIntervalTime返回值
    this.supportAnimationEvent = 'onanimationstart' in window; // 是否支持动画事件
    this.config = {
      itemDataType: this.itemDataTypeValue, // 子项定义的data-type
      activeClass: this.activeClassValue, // 活跃的幻灯片
      animationClass: {
        base: this.animationClassBaseValue, // 基础动画类
        leftIn: this.animationClassLeftInValue, // 从左侧进入
        leftOut: this.animationClassLeftOutValue, // 从左侧出去
        rightIn: this.animationClassRightInValue, // 从右侧进入
        rightOut: this.animationClassRightOutValue, // 从右侧出去
      },
      animationDuration: this.animationDurationValue || 500, // 动画持续时间，只在不支持动画事件的浏览器中启用
      intervalTime: this.intervalTimeValue || 3000, // 轮播间隔时间，该值需要比动画时间更长
    }
  }


  connect() {
    this.startAutoPlay();
  }

  // 动画开始
  itemAnimationStart = (e) => {
    this.inAnimation = true;
  }

  // 动画结束
  itemAnimationEnd = (e) => {
    const event = e instanceof Element ? null : (e || window.event);
    const elem = event ? (event.srcElement || event.target) : e;
    const { activeClass, animationClass } = this.config;
    if (elem.dataset.type === 'slide-item') {
      const rmClassNames = Object.values(animationClass);
      if (elem.classList.contains(animationClass.leftOut) || elem.classList.contains(animationClass.rightOut)) rmClassNames.push(activeClass);
      elem.classList.remove(...rmClassNames);
    }
    this.inAnimation = false;
  }

  // 手动控制动画完成
  simulateAnimation = () => {
    this.itemAnimationStart();
    const { animationDuration, itemDataType, activeClass } = this.config;
    setTimeout(() => {
      const items = this.element.querySelectorAll(`[data-type=${itemDataType}].${activeClass}`);
      Array.from(items).forEach(item => this.itemAnimationEnd(item));
    }, animationDuration);
  }

  // 上一个
  toLast = (e) => {
    const { itemDataType, activeClass, animationClass } = this.config;
    if (!this.inAnimation) {
      const items = this.element.querySelectorAll(`[data-type=${itemDataType}]`);
      if (items.length < 2) return;
      const currentIndex = Array.from(items).findIndex(element => element.classList.contains(activeClass));
      if (currentIndex < 0) {
        items[0].classList.add(activeClass);
        return;
      }
      items[currentIndex].classList.add(animationClass.base, animationClass.rightOut);
      const lastIndex = currentIndex <= 0 ? items.length - 1 : currentIndex - 1;
      items[lastIndex].classList.add(activeClass, animationClass.base, animationClass.leftIn);
      if (!this.supportAnimationEvent) this.simulateAnimation();
    }
  }

  // 下一个
  toNext = (e) => {
    const { itemDataType, activeClass, animationClass } = this.config;
    if (!this.inAnimation) {
      const items = this.element.querySelectorAll(`[data-type=${itemDataType}]`);
      if (items.length < 2) return;
      const currentIndex = Array.from(items).findIndex(element => {
        return element.classList.contains(activeClass)
      });
      if (currentIndex < 0) {
        items[0].classList.add(activeClass);
        return;
      }
      items[currentIndex].classList.add(animationClass.base, animationClass.leftOut);
      const nextIndex = currentIndex >= items.length - 1 ? 0 : currentIndex + 1;
      items[nextIndex].classList.add(activeClass, animationClass.base, animationClass.rightIn);
      if (!this.supportAnimationEvent) this.simulateAnimation();
    }
  }

  // 开始自动播放
  startAutoPlay = () => {
    if (this.autoPlayIntervalNum) this.stopAutoPlay();
    const { intervalTime } = this.config;
    this.autoPlayIntervalNum = setInterval(() => {
      requestAnimationFrame(this.toNext);
    }, intervalTime);
  }

  // 停止自动播放
  stopAutoPlay = () => {
    if (this.autoPlayIntervalNum) clearInterval(this.autoPlayIntervalNum);
    this.autoPlayIntervalNum = null;
  }
}
