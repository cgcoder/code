(function () {
  "use strict";

  chrome.storage.sync.get("enabled", ({ enabled }) => {
    if (!enabled) return;

    function start() {
      if (document.URL.indexOf("/results?") >= 0) return;

      let d = document.getElementById("primary");
      if (d && document.URL.indexOf("/watch?") <= 0) d.innerHTML = "";

      let sd = document.getElementById("secondary");
      if (sd) sd.innerHTML = "";

      sd = document.getElementById("secondary-inner");
      if (sd) sd.innerHTML = "";

      let comments = document.getElementById("comments");
      if (comments) comments.innerHTML = "";
    }

    setInterval(start, 250);
  });
})();
