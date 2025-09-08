class PasswordsController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: "Your password has been changed"
    else
      handle_password_errors(current_user)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
  end

  def handle_password_errors(user)
    error_messages = []

    user.errors.each do |error|
      case error.attribute
      when :current_password
        error_messages << "Current password is incorrect"
      when :password
        if error.type == :too_short
          error_messages << "New password must be at least #{User::MIN_PASSWORD} characters long"
        elsif error.type == :invalid
          error_messages << "Password format is invalid"
        else
          error_messages << "New password: #{error.message}"
        end
      when :password_confirmation
        error_messages << "Password confirmation doesn't match"
      when :password_digest
        error_messages << "Password format is invalid"
      end
    end

    if error_messages.empty?
      error_messages = current_user.errors.full_messages
    end

    flash[:error] = error_messages.first
  end
end
