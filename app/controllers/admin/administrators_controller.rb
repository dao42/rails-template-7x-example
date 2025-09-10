class Admin::AdministratorsController < Admin::BaseController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]
  before_action :ensure_super_admin, except: [:index, :show]

  def index
    @administrators = Administrator.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @administrator = Administrator.new
  end

  def create
    @administrator = Administrator.new(administrator_params)

    if @administrator.save
      redirect_to admin_administrator_path(@administrator), notice: 'Administrator was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Remove empty password parameters if not changing password
    update_params = administrator_params
    if update_params[:password].blank?
      update_params = update_params.except(:password, :password_confirmation)
    end

    if @administrator.update(update_params)
      redirect_to admin_administrator_path(@administrator), notice: 'Administrator was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @administrator.can_be_deleted_by?(current_admin)
      redirect_to admin_administrators_path, alert: 'Cannot delete this administrator.'
      return
    end

    @administrator.destroy
    redirect_to admin_administrators_path, notice: 'Administrator was successfully deleted.'
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    permitted_params = [:name, :password, :password_confirmation]
    # Only super admins can set roles
    permitted_params << :role if current_admin.can_manage_administrators?
    params.require(:administrator).permit(permitted_params)
  end

  def ensure_super_admin
    unless current_admin.can_manage_administrators?
      redirect_to admin_administrators_path, alert: 'Access denied. Super admin privileges required.'
    end
  end

end
