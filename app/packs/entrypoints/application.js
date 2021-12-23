// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "core-js/stable";
import "regenerator-runtime/runtime";
import "@stimulus/polyfills";
import 'waypoints/lib/noframework.waypoints';

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
const importAll = (r) => r.keys().map(r)
const images = require.context('../images', false, /\.(png|jpe?g|svg|webp)$/i)
importAll(images)
const imagePath = (name) => images(name, true)

import "controllers"
import "alpine/alpine_slide_show"
import "stylesheets/application.scss"

var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?dd080d712bbe176cb9ab961a5d9501e0";
  var s = document.getElementsByTagName("script")[0];
  s.parentNode.insertBefore(hm, s);
})();
