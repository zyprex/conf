mapkey('<Ctrl-y>', 'Debug', function() {
  Front.showPopup('(Escape to close)');
});
//////  https://github.com/brookhong/Surfingkeys/wiki/Example-Configurations
// Open a link in non-active new tab
map('F', 'gf');
// preview Link in Editor before open
function previewLink() {
  Hints.create("a[href]", (a) => Front.showEditor(a.href, (url) => tabOpenLink(url), 'url'));
};
mapkey('zf', '#7Preview link in editor before open', previewLink);
// Next/Prev Page
map(']', ']]');
map('[', '[[');
mapkey('K', '#1Click on the previous link on current page', previousPage);
mapkey('J', '#1Click on the next link on current page', nextPage);
// Move Tab Left/Right
map('>', '>>');
map('<', '<<');
// navigate number postfix Page
function changeNumberPostfixPage(n) {
  var url = window.location.href;
  var postfix_num = url.match(/\d+$/g);
  if (postfix_num === null) {
    return false;
  }
  var num_str = postfix_num[postfix_num.length - 1];
  var num = parseInt(num_str, 10) + n;
  var new_url = url.substr(0, url.length - num_str.length) + num;
  window.location.href = new_url;
  return true;
}
const nextNumberPostfixPage = ()=> changeNumberPostfixPage(1);
const prevNumberPostfixPage = ()=> changeNumberPostfixPage(-1);
mapkey(';ni', '#4Increase current URL\'s postfix number, and reload', nextNumberPostfixPage);
mapkey(';nd', '#4Decrease current URL\'s postfix number, and reload', prevNumberPostfixPage);
// element copy
mapkey('yC', "#7Yank first pre element", ()=> {
    var cssSelector = "pre";
    var elements = getVisibleElements(function (e, v) {
        if (e.matches(cssSelector)) {
            v.push(e);
        }
    });
    if (elements.length === 0 &&
        document.querySelector(cssSelector) !== null) {
        document.querySelector(cssSelector).scrollIntoView();
        elements = getVisibleElements(function (e, v) {
            if (e.matches(cssSelector)) {
                v.push(e);
            }
        });
    }
    Clipboard.write(elements[0].innerText);
});
mapkey('yE', '#7Yank Element info. copy link element id or classname', function () {
    var linksToYank = [];
    Hints.create("", function (element) {
        linksToYank.push('id: ' + element.id + '\n');
        linksToYank.push('innertext: ' + element.innerText + '\n');
        linksToYank.push('className: ' + element.className + '\n');
        linksToYank.push('href: ' + element.href + '\n');
        linksToYank.push('type: ' + element.type + '\n');
        linksToYank.push('style: ' + element.style + '\n');
        linksToYank.push('src: ' + element.src + '\n');
        linksToYank.push('alt: ' + element.alt + '\n');
        (Clipboard.write(linksToYank.join('\n')));
    });
});
// styles
Hints.characters = 'asdfgzxcvbnmqwertyuiop';
Visual.style('marks', 'background-color: #89a1e2;');
Visual.style('cursor', 'background-color: #AAFF44;');
// Settings Update
Object.assign(settings, {
  hintAlign:  "left",
  hintsThreshold: 31,
  richHintsForKeystroke: 1000,
  defaultSearchEngine: "s",
  language: "en",
  focusAfterClosed: "right",
  repeatThreshold: 99,
  tabsMRUOrder: false,
  historyMUOrder: false,
  intercetedErrors: ["*"],
  startToShowEmoji: 4,
  tabsThreshold: 9,
  modeAfterYank: "Normal",
  nextLinkRegex: /(\b(next)\b)|下页|下一页|后页|下頁|下一頁|後頁|>>|>|»/i,
  prevLinkRegex: /(\b(prev|previous)\b)|上页|上一页|前页|上頁|上一頁|前頁|<<|<|«/i,
  // pages/frontend.css
  // lib/ace/theme-chrome.js
  theme: `
.sk_theme , .ace_editor {
   font-family: CamingoCode, Hermit, sans-serif;
   font-size: 16px;
   background: #282828 !important;
   color: #ebdbb2 !important;
   caret-color: #a3ffa3 !important;
}
.ace_cursor {
   color: #a3ffa3 !important;
}
.ace_gutter {
  color: #c1a9c1 !important;
  background: #484848 !important;
}
.ace_gutter-active-line {
  color: #555500 !important;
  background: #191919 !important;
}
.sk_theme tbody {
  color: #b8bb26;
}
.sk_theme input {
  color: #d9dce0;
}
.sk_theme .url {
  color: #98971a;
}
.sk_theme .omnibar_visitcount {
    color: #6e97ff;
}
.sk_theme .omnibar_highlight {
  background: #b8bb26;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: #191919;
  color: #dbcbb0;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: #800000;
}
#sk_bubble * {
  color: #bababa !important;
}
#sk_usage span.annotation {
    color: #56b642;
    padding-left: 32px;
    line-height: 22px;
j}
`});
// Translate on [visual]q / Q
Front.registerInlineQuery({
    url: function(q) {
      return `http://apii.dict.cn/mini.php?q=${q}`;
    },
    parseResult: function (res) {
      var parser = new DOMParser();
      var doc = parser.parseFromString(res.text, "text/html");
      var mainResult = doc.querySelector("body");
      if (mainResult) {
        return mainResult.innerHTML;
      }
    }
});
// s[AliasX] o[AliasX]
// remove default alias in /pages/default.js
["g", "d", "b", "e",
 "w", "s", "h", "y"].forEach((v) => removeSearchAliasX(v, 's'));
["O", "om", "on", "oi", "oh", "ox",
 "ob", "og", "od", "ow", "oy"].forEach((v) => unmap(v));
mapkey('O/', '#1Open detected links from text', function() {
  Hints.create(runtime.conf.clickablePat, function(element) {
    window.location.assign(element[2]);
  }, {statusLine: "Open detected links from text"});
});
mapkey('Om', '#8Open URL from vim-like marks', function() {
  Front.openOmnibar({type: "VIMarks"});
});
mapkey('On', '#3Open newtab', function() {
  tabOpenLink((window.navigator.userAgent.indexOf("Firefox") > 0) ?
    "about:blank" : "chrome://newtab/");
});
mapkey('Oi', '#8Open incognito window', function() {
  RUNTIME('openIncognito', {url: window.location.href});
});
mapkey('Oh', '#8Open URL from history', function() {
  Front.openOmnibar({type: "History"});
});
mapkey('Ox', '#8Open recently closed URL', function() {
  Front.openOmnibar({type: "URLs", extra: "getRecentlyClosed"});
});
mapkey('Ot', '#8Open opened URL in current tab', function() {
    Front.openOmnibar({type: "URLs", extra: "getTabURLs"});
});
const openSearch = (x) => {
  if (x.sug !== undefined && x.sug_cb !== undefined) {
    addSearchAliasX(x.alias, x.name, x.url, 's', x.sug, x.sug_cb);
  } else {
    addSearchAliasX(x.alias, x.name, x.url, 's');
  }
  mapkey('o'+x.alias, '#8Open Search with alias '+x.alias+' ('+x.name+')',
    ()=> Front.openOmnibar({type: "SearchEngine", extra: x.alias})
  );
}
[
  {
    alias: 'bd',
    name: 'Baidu',
    url: 'https://www.baidu.com/s?wd=',
    sug: 'http://suggestion.baidu.com/su?cb=&wd=',
    sug_cb: function(response) {
      var res = response.text.match(/,s:\[("[^\]]+")]\}/);
      return res ? res[1].replace(/"/g, '').split(",") : [];
    }
  },
  {
    alias: 'bi',
    name: 'Bing',
    url: 'http://global.bing.com/search?setmkt=en-us&setlang=en-us&q=',
    sug: 'http://api.bing.com/osjson.aspx?query=',
    sug_cb: (response) => JSON.parse(response.text)[1],
  },
  {
    alias: 'sg',
    name: 'Sogou',
    url: 'https://www.sogou.com/web?ie=UTF-8&query=',
    sug: 'https://www.sogou.com/suggnew/ajajjson?key=',
    sug_cb: function (response) {
      // Front.showPopup(JSON.stringify(response))
      var res = response.text;
      var start = res.indexOf('[', res.indexOf('[') + 1) + 1;
      var end = res.indexOf(']');
      var res = res.substring(start, end).replace(/"/g, '').split(',');
      return res;
    }
  },
  {
    alias: 'gh',
    name: 'Github',
    url: 'https://github.com/search?q=',
    sug: 'https://api.github.com/search/repositories?order=desc&q=',
    sug_cb: function(response) {
      var res = JSON.parse(response.text)['items'];
      return res ? res.map(function(r){
        return {
          title: r.description,
          url: r.html_url
        };
      }) : [];
    }
  },
  {
    alias: 'aw',
    name: 'ArchWiki',
    url: 'https://wiki.archlinux.org/index.php?search=',
    sug: 'https://wiki.archlinux.org/api.php?action=opensearch&format=json&formatversion=2&limit=10&search=',
    sug_cb: (response) => JSON.parse(response.text)[1],
  },
  { alias: 'gt', name: 'GoogleTranslate', url: 'https://translate.google.cn/#view=home&op=translate&sl=auto&tl=zh-CN&text=' },
  { alias: 'yp', name: 'Yelp', url: 'https://www.yelp.com/search?find_desc=', },
  { alias: 'sc', name: 'SearchCode', url: 'https://searchcode.com/?q=', },
  { alias: 'sl', name: 'Slant', url:'https://www.slant.co/search?query=', },
  { alias: 'at', name: 'alternativeto', url:'https://alternativeto.net/browse/search?q=', },
  { alias: 'ol', name: 'Onelook', url:'https://onelook.com/?ls=a&w=', },
  { alias: 'md', name: 'MDN', url:'https://developer.mozilla.org/en-US/search?q=', },
  { alias: 'cr', name: 'cppreference', url:'https://global.bing.com/search?q=sites%3A%20cppreference%20', },
  { alias: 'dh', name: 'devhints', url:'https://devhints.io/?q=', },
  { alias: 'zd', name: 'zdic', url:'https://www.zdic.net/hans/', },
  { alias: 'c4', name: 'Crx4Chrome', url:'https://www.baidu.com/s?q6=www.crx4chrome.com&q1=', },
  { alias: 'gf', name: 'greasyfork', url:'https://greasyfork.org/en/scripts?q=', },
  { alias: 'sx', name: 'searx', url:'https://searx.thegpm.org/?q=', },
  { alias: 'mj', name: 'mojeek', url:'https://www.mojeek.com/search?q=', },
  { alias: 'qw', name: 'Qwant', url:'https://www.qwant.com/?q=', },
  { alias: 'ql', name: 'QwantLite', url:'https://lite.qwant.com/?q=', },
  { alias: 'mg', name: 'Metager', url:'https://metager.de/meta/meta.ger3?eingabe=', },
  { alias: 'sw', name: 'swisscows', url:'https://swisscows.com/web?query=', },
  { alias: 'li', name: 'lilo', url:'https://search.lilo.org/?q=', },
  { alias: 'kp', name: 'knowledgepicker', url:'https://knowledgepicker.com/search?q=', },
  { alias: 'sf', name: 'sourceforge', url:'https://sourceforge.net/directory/?q=', },
].forEach(x=>openSearch(x));
