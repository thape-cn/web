# frozen_string_literal: true

class AboutsController < ApplicationController
  def show
    @about_page = AboutPage.first
  end

  def culture
  end

  def about_us
    redirect_to about_path, status: :moved_permanently
  end
end
