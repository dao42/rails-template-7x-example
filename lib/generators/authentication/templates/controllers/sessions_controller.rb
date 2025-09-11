class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:devices, :destroy_one]

  def devices
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to _strong_root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session = Current.session
    @session.destroy!
    cookies.delete(:session_token)
    redirect_to(_strong_root_path, notice: "That session has been logged out")
  end

  def destroy_one
    @session = Current.user.sessions.find(params[:id])
    @session.destroy!
    redirect_to(session_devices_path, notice: "That session has been logged out")
  end
end
