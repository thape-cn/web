# frozen_string_literal: true

json.id @work.id
json.title I18n.with_locale(:cn) { @work.project_name }
json.subtitle I18n.with_locale(:en) { @work.project_name }
if @work.snapshot_jpg.present? && @work.snapshot_jpg.url.present?
  json.cover @work.snapshot_jpg.url + "?x-oss-process=image/resize,w_750/quality,q_80"
end
json.pictures @work.work_pictures.collect { |work_picture| [work_picture.album_jpg.url + "?x-oss-process=image/resize,w_750/quality,q_80", work_picture.album_jpg.url] }
if @work.client.present?
  json.client @work.client.split(/\r?\n/)
end
if @work.design_completion_lines.present?
  json.design_completion @work.design_completion_lines.split(/\r?\n/)
elsif @work.design_completion.present? && !@work.design_completion.year.zero?
  json.design_completion @work.design_completion.year
end
if @work.construction_completion_lines.present?
  json.construction_completion @work.construction_completion_lines.split(/\r?\n/)
elsif @work.construction_completion.present? && !@work.construction_completion.year.zero?
  json.construction_completion @work.construction_completion.year
end
if @work.city.present?
  json.location @work.city.name
end
if @work.planning_area.present? && !@work.planning_area.zero?
  json.planning_area @work.planning_area
end
if @work.site_area.present? && !@work.site_area.zero?
  json.site_area @work.site_area
end
if @work.architecture_area_lines.present?
  json.architecture_area @work.architecture_area_lines.split(/\r?\n/)
elsif @work.architecture_area.present? && !@work.architecture_area.zero?
  json.architecture_area @work.architecture_area
end
if @work.services.present?
  json.services @work.services.split(/\r?\n/)
end
if @work.team.present?
  json.team @work.team
end
if @work.cooperation.present?
  json.cooperation @work.cooperation.split(/\r?\n/)
end
if @work.awards.present?
  json.awards @work.awards.split(/\r?\n/)
end
