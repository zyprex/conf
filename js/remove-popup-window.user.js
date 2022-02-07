// ==UserScript==
// @name         remove popup window
// @namespace    http://tampermonkey.net/
// @version      0.1.4
// @description  get rid of abnoxious html elements
// @author       zyprex
// @match        *www.zhihu.com/*
// @match        *zhuanlan.zhihu.com/*
// @match        *stackoverflow.com/*
// @match        *meta.stackoverflow.com/*
// @match        *superuser.com/*
// @match        *stackexchange.com/*
// @match        *unix.stackexchange.com/*
// @match        *askubuntu.com/*
// @match        *serverfault.com/*
// @match        *cn.bing.com/*
// @grant        none
// ==/UserScript==
let gID = 0; // global interval ID
let gCD = 0; // global count down
let url = window.location.href;

(function() {
  'use strict';
  [
    [/\.zhihu\.com/, ['div.Modal-wrapper']],
    [/(stackoverflow|stackexchange|askubuntu|serverfault|superuser)\.com/, ['div.js-consent-banner']],
    [/cn\.bing\.com/, ['div#ev_talkbox_wrapper']],
  ].map(v => { if (v[0].test(url)) { Ban(v[1]); } });
  setTimeout(() => { clearInterval(gID); }, 30000);
})();

/*
 * Utility Functions
 */
function Ban(selector_list) {
  gCD = selector_list.length;
  gID = setInterval(() => {
    selector_list.map(v => {
      let elem = document.querySelector(v);
      if (elem) {
        elem.remove();
        gCD--;
      }
      if (gCD <= 0) {
        clearInterval(gID);
        console.log('remove-popup-window.js: finished !');
      }
    });
  }, 100);
}
