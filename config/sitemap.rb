# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://www.thape.com'
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  add residential_works_path, priority: 0.60, changefreq: 'weekly'
  add residential_rental_works_path, priority: 0.60, changefreq: 'weekly'
  add residential_community_works_path, priority: 0.60, changefreq: 'weekly'
  add residential_residence_works_path, priority: 0.60, changefreq: 'weekly'
  add demonstration_zone_works_path, priority: 0.60, changefreq: 'weekly'
  add office_works_path, priority: 0.60, changefreq: 'weekly'
  add supertall_works_path, priority: 0.60, changefreq: 'weekly'
  add mixed_used_tod_works_path, priority: 0.60, changefreq: 'weekly'
  add commercial_works_path, priority: 0.60, changefreq: 'weekly'
  add cultural_works_path, priority: 0.60, changefreq: 'weekly'
  add education_works_path, priority: 0.60, changefreq: 'weekly'
  add medical_care_works_path, priority: 0.60, changefreq: 'weekly'
  add urban_design_works_path, priority: 0.60, changefreq: 'weekly'
  add hospitality_works_path, priority: 0.60, changefreq: 'weekly'
  add urban_planning_works_path, priority: 0.60, changefreq: 'weekly'
  add landscape_works_path, priority: 0.60, changefreq: 'weekly'
  add interior_works_path, priority: 0.60, changefreq: 'weekly'
  add works_path, priority: 0.60, changefreq: 'weekly'

  Work.find_each do |work|
    add work_path(work), lastmod: work.updated_at
  end
  City.where.not(china_area_name: nil).each do |city|
    next if city.works.size.zero?
    add work_path(id: city.url_name), changefreq: 'weekly'
  end
  add leadership_index_path, priority: 0.60, changefreq: 'weekly'
  Person.where(leaving_date: nil).find_each do |person|
    add leadership_path(id: person.url_name), lastmod: person.updated_at
  end
  City.where(id: CityPerson.distinct.pluck(:city_id)).where.not(url_name: nil).each do |city|
    add leadership_path(id: city.url_name), changefreq: 'weekly'
  end
  add about_path, priority: 0.60, changefreq: 'weekly'
  add culture_path, priority: 0.60, changefreq: 'weekly'
  add building_path, priority: 0.60, changefreq: 'weekly'
  add interior_path, priority: 0.60, changefreq: 'weekly'
  add planning_path, priority: 0.60, changefreq: 'weekly'
  add landscape_path, priority: 0.60, changefreq: 'weekly'
  add vetting_path, priority: 0.60, changefreq: 'weekly'
  add consluting_path, priority: 0.60, changefreq: 'weekly'
  add vr_tech_path, priority: 0.60, changefreq: 'weekly'
  add biz_map_path, priority: 0.60, changefreq: 'weekly'
  add statement_sites_path, priority: 0.60, changefreq: 'weekly'
  add privacy_sites_path, priority: 0.60, changefreq: 'weekly'
  add disclaimer_sites_path, priority: 0.60, changefreq: 'weekly'
  add news_index_path, priority: 0.60, changefreq: 'weekly'
  Info.where(hide_in_index_news: false).find_each do |info|
    add news_path(info), lastmod: info.updated_at
  end
end
