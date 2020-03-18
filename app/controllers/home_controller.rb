class HomeController < ApplicationController
  def show
    flash[:alert] = "Hello TailwindUI!"
  end
end
