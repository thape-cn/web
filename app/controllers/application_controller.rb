# frozen_string_literal: true

class ApplicationController < ActionController::Base
  wechat_api

  around_action :with_request_locale
  before_action :set_ts
  before_action :prepare_seo_variable
  before_action :set_not_mobile_wechat

  private

  # Keep the selected locale scoped to this request. Assigning I18n.locale
  # directly would leave it set for whatever runs next on the same thread,
  # which means the following request or background job could render or store
  # translations in the previous visitor's language.
  def with_request_locale(&block)
    I18n.with_locale(request_locale, &block)
  end

  def request_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      cookies["locale"] = {value: params[:locale], expires: 1.year.from_now}
      params[:locale].to_sym
    elsif cookies["locale"] && I18n.available_locales.include?(cookies["locale"].to_sym)
      cookies["locale"].to_sym
    elsif (header_locale = extract_locale_from_accept_language_header).present? && I18n.available_locales.include?(header_locale.to_sym)
      cookies["locale"] = {value: header_locale, expires: 1.year.from_now}
      header_locale.to_sym
    else
      :cn
    end
  end

  def extract_locale_from_accept_language_header
    @http_locale ||= request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
  rescue Exception
    "cn"
  end

  def set_ts
    if params[:ts].present?
      cookies["ts"] = {value: params[:ts], expires: 1.year.from_now}
    end
  end

  def prepare_seo_variable
    @seo = Seo.find_by(seo_name: "首页")
  end

  def set_not_mobile_wechat
    if browser.wechat? && !browser.device.mobile?
      flash.now[:alert] = "请使用系统浏览器打开本站点".html_safe
    end
  end
end
