class NewsController < ApplicationController
  def show
    @info = Info.find(params[:id])
  end

  def index
  end
end
