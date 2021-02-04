# frozen_string_literal: true

json.list @works do |work|
  json.id work.id
  json.title I18n.with_locale(:cn) { work.project_name }
  json.subtitle I18n.with_locale(:en) { work.project_name }
  if work.snapshot_jpg.present? && work.snapshot_jpg.url.present?
    json.cover work.snapshot_jpg.url + '?x-oss-process=image/resize,w_750/quality,q_80'
  end
  json.lat work.coordinate_lat
  json.lng work.coordinate_lng
end
json.total @works.length
