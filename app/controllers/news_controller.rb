class NewsController < ApplicationController
  def show
    @info = Info.find(params[:id])
  end
end
