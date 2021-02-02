json.total @total
json.list @works do |work|
  json.id work.id
  json.title I18n.with_locale(:cn) { work.project_name }
  json.subtitle I18n.with_locale(:en) { work.project_name }
  if work.snapshot_jpg.present? && work.snapshot_jpg.url.present?
    json.cover work.snapshot_jpg.url
  end
  json.client work.client
  json.team work.team
end