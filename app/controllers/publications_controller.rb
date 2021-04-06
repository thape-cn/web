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
      { title: '上海城市更新', subtitle: '五种策略', url: '/book2-1.jpg', width: '100%', height: '100%', category: 1 },
      { title: 'ZHENGZHOU郑州', subtitle: '从火车之城到地铁大都会', url: '/book2-2.jpg', width: '100%', height: '77.8%', category: 1 },
      { title: '上海城市更新', subtitle: '五种策略', url: '/book2-1.jpg', width: '100%', height: '100%', category: 2 },
      { title: 'ZHENGZHOU郑州', subtitle: '从火车之城到地铁大都会', url: '/book2-2.jpg', width: '100%', height: '77.8%', category: 2 },
      { title: '上海城市更新', subtitle: '五种策略', url: '/book2-1.jpg', width: '100%', height: '100%', category: 2 },
      { title: '上海城市更新', subtitle: '五种策略', url: '/book2-1.jpg', width: '100%', height: '100%', category: 3 },
      { title: 'ZHENGZHOU郑州', subtitle: '从火车之城到地铁大都会', url: '/book2-2.jpg', width: '100%', height: '77.8%', category: 3 },
      { title: '上海城市更新', subtitle: '五种策略', url: '/book2-1.jpg', width: '100%', height: '100%', category: 3 },
      { title: 'ZHENGZHOU郑州', subtitle: '从火车之城到地铁大都会', url: '/book2-2.jpg', width: '100%', height: '77.8%', category: 3 },
    ]

    @publication_categoty = [
      { id: 1, title: '专著书籍' },
      { id: 2, title: '规范标准' },
      { id: 3, title: '论文专利' },
    ]
  end
end
