import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "marker", "categoryOrigin", "categoryFixed" ]

  connect() {
    this.resize();
  }

  resize() {
    const screenWidth = document.body.clientWidth;
    if (screenWidth < 768) {
      const originPz = this.categoryOriginTarget.getBoundingClientRect();
      const where = originPz.y <= 50;
      this.categoryFixedTarget.style.display = !where ? 'none' : '';
    }
  }

  clickCate() {
    const markerPz = this.markerTarget.getBoundingClientRect();
    const curScrollTop = document.documentElement.scrollTop;
    document.documentElement.scrollTo({ top: curScrollTop + markerPz.top - 50 });
  }

  downloadFile(e) {
    const url = e.target.dataset.url;
    if (url) {
      const ext = url.split('/').pop();
      const x = new XMLHttpRequest();
      x.open('GET', url);
      x.responseType = 'blob';
      x.onload = function(e) {
        const blobUrl = window.URL.createObjectURL(x.response)
        const a = document.createElement('a');
        document.body.appendChild(a);
        a.download = ext;
        a.href = blobUrl;
        a.click();
        document.body.removeChild(a);
      }
      x.send();
    }
  }
}
