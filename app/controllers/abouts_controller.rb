class AboutsController < ApplicationController
  def show
    @service_file = ServiceFile.first
  end

  def culture
  end

  def about_us
    redirect_to about_path, :status => :moved_permanently
  end
end
