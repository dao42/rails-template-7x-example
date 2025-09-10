class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: [:new, :create]

  before_action do
    @full_render = true
  end

  def new
    if not Administrator.first
      flash.now[:notice] = 'Use admin/admin for the first login to the system'
    end
  end

  def create
    create_first_admin!
    admin = Administrator.find_by(name: params[:name])
    if admin && admin.authenticate(params[:password])
      admin_sign_in(admin)
      redirect_to admin_root_path
    else
      flash.now[:alert] = 'Username or password is wrong'
      render 'new'
    end
  end

  def destroy
    admin_sign_out
    redirect_to admin_login_path
  end

  private
  def create_first_admin!
    return if Administrator.first
    logger.info("System have no admins, create the first one")
    admin = Administrator.new(name: 'admin', password: 'admin', role: 'super_admin')
    admin.save!(validate: false)
  end
end
