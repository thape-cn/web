class NewsController < ApplicationController
  def show
    @info = Info.find(params[:id])
  end

  def index
    @infos = Info.where(hide_in_index_news: false).order(position: :asc).limit(20)
  end
end
