import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "marker", "categoryOrigin", "categoryFixed", "wxDownload" ]

  connect() {
    this.resize();
  }

  resize() {
    if (this.hasCategoryOriginTarget && this.hasCategoryFixedTarget) {
      const screenWidth = document.body.clientWidth;
      if (screenWidth < 768) {
        const originPz = this.categoryOriginTarget.getBoundingClientRect();
        const where = originPz.y <= 50;
        if (where) {
          this.categoryFixedTarget.scrollTo({ left: this.categoryOriginTarget.scrollLeft });
          this.categoryFixedTarget.style.display = '';
        } else {
          this.categoryFixedTarget.style.display = 'none';
        }
        this.categoryFixedTarget.style.width = `${originPz.width}px`;
      }
    }
  }

  clickCate() {
    const markerPz = this.markerTarget.getBoundingClientRect();
    const curScrollTop = document.documentElement.scrollTop;
    document.documentElement.scrollTo({ top: curScrollTop + markerPz.top - 50 });
  }

  onCategoryFixedScroll(e) {
    if (this.hasCategoryOriginTarget) {
      this.categoryOriginTarget.scrollTo({ left: e.target.scrollLeft });
    }
  }

  downloadFile(e) {
    const isWx = navigator.userAgent.toLowerCase().indexOf('micromessenger') !== -1;
    if (isWx) {
      if (this.hasWxDownloadTarget) {
        this.wxDownloadTarget.style.display = 'block';
      }
    } else {
      const url = e.target.getAttribute('href');
      const download = e.target.getAttribute('download');
      const a = document.createElement('a');
      a.href = url;
      a.download = download;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    }
  }
}
