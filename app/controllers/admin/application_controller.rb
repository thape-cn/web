# frozen_string_literal: true

# Deliberately independent of the customer-facing controller's cookies and callbacks.
class Admin::ApplicationController < ActionController::Base
  layout "admin/application"
  protect_from_forgery with: :exception
  before_action :require_admin
  around_action :with_admin_locale
  helper_method :current_admin, :admin_locale
  helper Admin::ApplicationHelper

  private

  def current_admin
    @current_admin ||= Admin::User.find_by(id: session[:admin_user_id])
  end

  def require_admin
    redirect_to admin_login_path unless current_admin
  end

  def admin_locale
    %w[cn en].include?(params[:locale]) ? params[:locale] : session[:admin_locale].presence || "cn"
  end

  def with_admin_locale(&block)
    session[:admin_locale] = admin_locale
    I18n.with_locale(admin_locale, &block)
  end

  def default_url_options
    {locale: admin_locale}
  end
end
