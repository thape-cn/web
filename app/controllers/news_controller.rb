class NewsController < ApplicationController
  def show
    @info = Info.find(params[:id])

    @seo.home_title = if @info.seo_title.present?
      @info.seo_title
    else
      @info.title
    end
    @seo.keywords = if @info.seo_keywords.present?
      @info.seo_keywords
    else
      @info.title
    end
    @seo.description = if @info.seo_description.present?
      @info.seo_description
    else
      "#{@info.title} #{@info.sub_title}"
    end
    @seo.abstract = @seo.description

    two_random_works = Work.pluck(:id).sample(2)
    @first_work = Work.find two_random_works[0]
    @second_work = Work.find two_random_works[1]

    info_id_in_sequence = Info.where(hide_in_index_news: false).order(id: :desc).pluck(:id)
    previous_info_id = if info_id_in_sequence.first == @info.id
      info_id_in_sequence.last
    elsif info_id_in_sequence.index(@info.id)
      info_id_in_sequence[info_id_in_sequence.index(@info.id) - 1]
    else
      Info.where(hide_in_index_news: false).first.id
    end

    next_info_id = if info_id_in_sequence.last == @info.id
      info_id_in_sequence.first
    elsif info_id_in_sequence.index(@info.id)
      info_id_in_sequence[info_id_in_sequence.index(@info.id) + 1]
    else
      Info.where(hide_in_index_news: false).last.id
    end

    @previous_info = Info.find previous_info_id
    @next_info = Info.find next_info_id
    @tail_home = TailHome.first
  end

  def index
    @seo.home_title = "天华建筑公司动态-新闻动态"
    @seo.description = "公司动态,公司新闻"
    @seo.abstract = @seo.description
    @seo.keywords = "天华建设新闻栏目为您提供最新的天华建筑公司动态，公司新闻等内容，欢迎访问天华建筑官网了解更多天华建筑最新动态"

    @tail_home = TailHome.first
    @infos = Info.where(hide_in_index_news: false).where.not(id: @tail_home.hero_news_id)
      .order(position: :asc).page(params[:page]).per(params[:per_page])
  end
end
