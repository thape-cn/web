# frozen_string_literal: true

class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :require_admin, only: [:new, :create]

  def new
    redirect_to admin_root_path if current_admin
  end

  def create
    credentials = params.require(:session).permit(:email, :password)
    user = Admin::User.find_by(email: credentials[:email].to_s.strip.downcase)
    if user&.authenticate(credentials[:password].to_s)
      locale = admin_locale
      reset_session
      session[:admin_user_id] = user.id
      session[:admin_locale] = locale
      redirect_to admin_root_path
    else
      flash.now[:alert] = "邮箱或密码不正确"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to admin_login_path
  end
end
