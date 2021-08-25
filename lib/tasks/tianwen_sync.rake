# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news sync_works sync_persons sync_portfolios sync_publications sync_map_contacts sync_intro]

  desc 'Sync news'
  task sync_news: :environment do
    d4_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D4.xml')

    Info.all.find_each do |info|
      tmpl = File.open(d4_tmpl_path) { |f| Nokogiri::XML(f) }
      info.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "news_#{info.id}")
    end
  end

  desc 'Sync works'
  task sync_works: :environment do
    e1_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'E1.xml')
    Work.all.find_each do |work|
      tmpl = File.open(e1_tmpl_path) { |f| Nokogiri::XML(f) }
      work.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "works_#{work.id}")
    end
  end

  desc 'Sync persons'
  task sync_persons: :environment do
    tmpl_path = Rails.root.join('public', 'tianwen_tile', 'default.xml')
    Person.where(leaving_date: nil).all.find_each do |person|
      tmpl = File.open(tmpl_path) { |f| Nokogiri::XML(f) }
      person.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "persons_#{person.id}")
    end
  end

  desc 'Sync portfolios'
  task sync_portfolios: :environment do
    f3_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'F3.xml')
    Portfolio.all.find_each do |portfolio|
      tmpl = File.open(f3_tmpl_path) { |f| Nokogiri::XML(f) }
      portfolio.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "portfolios_#{portfolio.id}")
    end
  end

  desc 'Sync publications'
  task sync_publications: :environment do
    f3_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'F3.xml')
    Publication.all.find_each do |publication|
      tmpl = File.open(f3_tmpl_path) { |f| Nokogiri::XML(f) }
      publication.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "publications_#{publication.id}")
    end
  end

  desc 'Sync map_contacts'
  task sync_map_contacts: :environment do
    g2_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'G2.xml')
    MapContact.all.find_each do |map_contact|
      tmpl = File.open(g2_tmpl_path) { |f| Nokogiri::XML(f) }
      map_contact.write_tianwen_xml(tmpl)
      Tianwen.xml_to_dir(tmpl.to_xml, "map_contacts_#{map_contact.id}")
    end
  end

  desc 'Sync intro'
  task sync_intro: :environment do
    d2_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D2.xml')
    # 关于我们
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_about_us" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("关于我们")) # 标题, 必选
    keywords = [
      I18n.t('abouts.intro.title'),
      I18n.t('abouts.research.title'),
      I18n.t('abouts.design_lab.title'),
      I18n.t('abouts.t_plus.title'),
      I18n.t('abouts.perfection_pursuer.title'),
    ];
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(keywords.join(';'))) # 关键词, 必选
    about = AboutPage.first
    content = [
      about.thape_intro,
      I18n.t('abouts.research.content').join(';'),
      I18n.t('abouts.design_lab.content').join(';'),
      I18n.t('abouts.t_plus.content').join(';'),
      I18n.t('abouts.perfection_pursuer.content').join(';'),
    ]
    tmpl.at_css('TRS_CONTENT').add_child(tmpl.create_cdata(content.join(';'))) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.about_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(about.about_h1.url(thumb: '?x-oss-process=image/resize,w_327'))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'about_us')

    # 服务
    service_file = ServiceFile.first
    root_url = Rails.application.routes.url_helpers.root_url.chop

    # 建筑
    seo = Seo.find_by(seo_name: '建筑设计服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_building" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(I18n.t('services.building.chinese_title'))) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.building_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.building_url)) # 链接, 必选
    background_img = ActionController::Base.helpers.asset_pack_url(I18n.t('services.building.background_img'), host: root_url)
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(background_img)) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'building')
    # 室内
    seo = Seo.find_by(seo_name: '室内设计服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_interior" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("室内")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.interior_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.interior_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.interior.background_img'), host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'interior')
    # 规划
    seo = Seo.find_by(seo_name: '城市规划服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_planning" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("规划")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.planning_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.planning_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.planning.background_img'), host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'planning')
    # 景观
    seo = Seo.find_by(seo_name: '景观设计服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_landscape" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("景观")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.landscape_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.landscape_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.landscape.background_img'), host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'landscape')
    # 审图
    seo = Seo.find_by(seo_name: '审图服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_vetting" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("审图")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.vetting_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.vetting_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.vetting.background_img'), host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'vetting')
    # 技术咨询
    seo = Seo.find_by(seo_name: '技术咨询服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_consluting" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("技术咨询")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.consluting_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.consluting_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.consluting.background_img'), host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'consluting')
    # 可视化
    seo = Seo.find_by(seo_name: '可视化服务')
    tmpl = File.open(d2_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = "web_vr_tech" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata("可视化")) # 标题, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo.keywords)) # 关键词, 必选
    tmpl.at_css('TRS_ATTACH_CONTENT').add_child(tmpl.create_cdata(service_file.vrtech_intro)) # 内容, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.vr_tech_url)) # 链接, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(ActionController::Base.helpers.asset_pack_url(I18n.t('services.vrtech.background_img')[0], host: root_url))) # 缩略图, 必选
    tmpl.at_css('TRS_OPP').content = 1
    Tianwen.xml_to_dir(tmpl.to_xml, 'vr_tech')
  end
end
