(function() {
  window.App = window.App || {}
  window.App.adminSidebar = {
    saveSidebarScrollPosition: function() {
      var adminPage = this.page();
      if (adminPage) {
        var sidebar = adminPage.querySelector('.sidebar');
        if (sidebar) {
          var sidebarScrollTop = sidebar.scrollTop;
          localStorage.setItem('admin-SidebarScrollTop', sidebarScrollTop);
        }
      }
    },

    restoreSidebarScrollPosition: function() {
      var adminPage = this.page();
      if (adminPage) {
        var sidebar = adminPage.querySelector('.sidebar');
        var sidebarScrollTop = localStorage.getItem('admin-SidebarScrollTop');
        if (sidebar && sidebarScrollTop) {
          sidebar.scrollTop = sidebarScrollTop;
        }
      }
    },

    clearSidebarScrollPosition: function() {
      localStorage.setItem('admin-SidebarScrollTop', 0);
    },

    page: function() {
      return document.querySelector('.admin-page');
    }
  };
}).call(this);

document.addEventListener('turbo:load', function() {
  var component = document.querySelector('.admin-page');
  if (component) {
    App.adminSidebar.restoreSidebarScrollPosition();
  }
});

document.addEventListener('turbo:before-render', function() {
  var component = document.querySelector('.admin-page');
  if (component) {
    App.adminSidebar.saveSidebarScrollPosition();
  } else {
    App.adminSidebar.clearSidebarScrollPosition();
  }
});
