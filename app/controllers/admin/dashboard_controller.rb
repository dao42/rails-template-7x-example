class Admin::DashboardController < Admin::BaseController
  # Do not forget to add menu item in app/views/shared/admin/_sidebar.html.erb
  def index
    @admin_count = Administrator.all.size
  end
end
