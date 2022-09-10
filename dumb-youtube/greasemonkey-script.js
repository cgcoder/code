// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    function start() {
         let d = document.getElementById('primary');
        if (d && document.URL.indexOf('/watch?') <= 0) d.remove();

        let sd = document.getElementById('secondary');
        if (sd) sd.remove();

        let comments = document.getElementById('comments');
        if (comments) comments.remove();
    }

     var timeout = setInterval( function() { start(); }, 1000);
})();
