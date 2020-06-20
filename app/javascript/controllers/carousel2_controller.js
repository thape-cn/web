import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    this.inAnimation = false; // 动画是否正在进行中
    this.autoPlayIntervalNum = null; // 动画自动播放的setIntervalTime返回值
    this.config = {
      itemDataType: this.data.get('itemDataType'), // 子项定义的data-type
      activeClass: this.data.get('activeClass'), // 活跃的幻灯片
      animationClass: {
        base: this.data.get('animationClassBase'), // 基础动画类
        leftIn: this.data.get('animationClassLeftIn'), // 从左侧进入
        leftOut: this.data.get('animationClassLeftOut'), // 从左侧出去
        rightIn: this.data.get('animationClassRightIn'), // 从右侧进入
        rightOut: this.data.get('animationClassRightOut'), // 从右侧出去
      },
      intervalTime: Number(this.data.get('intervalTime')) || 3000, // 轮播间隔时间，该值需要比动画时间更长
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
    const elem = e.target;
    const { activeClass, animationClass } = this.config;
    if (elem.dataset.type === 'slide-item') {
      const rmClassNames = Object.values(animationClass);
      if (elem.classList.contains(animationClass.leftOut) || elem.classList.contains(animationClass.rightOut)) rmClassNames.push(activeClass);
      elem.classList.remove(...rmClassNames);
    }
    this.inAnimation = false;
  }

  // 上一个
  toLast = (e) => {
    const { itemDataType, activeClass, animationClass } = this.config;
    if (!this.inAnimation) {
      const items = this.element.querySelectorAll(`[data-type=${itemDataType}]`);
      if (items.length < 2) return;
      const currentIndex = [...items].findIndex(element => element.classList.contains(activeClass));
      if (currentIndex < 0) {
        items[0].classList.add(activeClass);
        return;
      }
      items[currentIndex].classList.add(animationClass.base, animationClass.rightOut);
      const lastIndex = currentIndex <= 0 ? items.length - 1 : currentIndex - 1;
      items[lastIndex].classList.add(activeClass, animationClass.base, animationClass.leftIn);
    }
  }

  // 下一个
  toNext = (e) => {
    const { itemDataType, activeClass, animationClass } = this.config;
    if (!this.inAnimation) {
      const items = this.element.querySelectorAll(`[data-type=${itemDataType}]`);
      if (items.length < 2) return;
      const currentIndex = [...items].findIndex(element => element.classList.contains(activeClass));
      if (currentIndex < 0) {
        items[0].classList.add(activeClass);
        return;
      }
      items[currentIndex].classList.add(animationClass.base, animationClass.leftOut);
      const nextIndex = currentIndex >= items.length - 1 ? 0 : currentIndex + 1;
      items[nextIndex].classList.add(activeClass, animationClass.base, animationClass.rightIn);
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
    this.autoIntervalNum = null;
  }
}
