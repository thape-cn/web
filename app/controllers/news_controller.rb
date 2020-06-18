class NewsController < ApplicationController
  def show
    @info = Info.find(params[:id])

    two_random_works = Work.pluck(:id).sample(2)
    @first_work = Work.find two_random_works[0]
    @second_work = Work.find two_random_works[1]
  end

  def index
    @infos = Info.where(hide_in_index_news: false).order(position: :asc).limit(20)
  end
end
