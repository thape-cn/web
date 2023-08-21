# frozen_string_literal: true

json.list @people do |person|
  json.id person.id
  json.url leadership_url(id: person.url_name)
  json.cn_name I18n.with_locale(:cn) { person.name }
  json.en_name I18n.with_locale(:en) { person.name }
  json.cn_title I18n.with_locale(:cn) { person.title }
  json.en_title I18n.with_locale(:en) { person.title }
  json.photo person.photo.url
end
json.total @people.count
