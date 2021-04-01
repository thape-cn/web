# frozen_string_literal: true

class PublicationsController < ApplicationController
  def index
    @works = [
      { title: '天华2020作品集', subtitle: '文旅康养', url: '/book1-1.png', width: '100%', height: '100%' },
      { title: '天华2020作品集', subtitle: '人居社区', url: '/book1-2.png', width: '100%', height: '100%' },
      { title: '天华2020作品集', subtitle: '城市设计', url: '/book1-3.png', width: '100%', height: '100%' },
      { title: '天华2020作品集', subtitle: '办公商业', url: '/book1-4.png', width: '100%', height: '100%' },
      { title: '天华2018作品集', subtitle: '居住建筑', url: '/book1-5.jpg', width: '85%', height: '85%' },
      { title: '天华2018作品集', subtitle: '公共建筑', url: '/book1-6.jpg', width: '85%', height: '85%' },
    ]
    @publications = [
      { title: '上海城市更新五种策略', url: '/book2-1.jpg', width: '100%', height: '100%' },
      { title: '郑州-从火车之城到地铁大都会', url: '/book2-2.jpg', width: '100%', height: '77.8%' },
    ]
  end
end
