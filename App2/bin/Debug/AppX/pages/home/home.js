(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/home/home.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            // TODO: Initialize the page here.
            WinJS.Utilities.query("a").listen("click", this.clickEventHandler);
        },
        clickEventHandler: function (event) {
            event.preventDefault();
            var link = event.target;
            WinJS.Navigation.navigate(link.href);
        }
    });
})();
