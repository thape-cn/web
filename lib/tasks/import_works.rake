# frozen_string_literal: true

require "csv"

namespace :import_works do
  desc "Import the CSV to works"
  task :from_csv, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      category_names = row["大类别"].split(",")

      project_name_cn = row["中文项目名称"]&.strip
      project_name_en = row["英文项目名称"]&.strip

      client_cn = row["客户名称"]&.strip
      client_en = row["CLIENT"]&.strip

      design_completion = row["设计完成时间"]&.strip

      city_name = row["所在城市"]&.strip
      china_area_name = row["区域"]&.strip
      location = row["LOCATION"]&.strip

      site_area = row["用地面积"]&.strip
      planning_area = row["规划面积"]&.strip
      architecture_area = row["建筑面积"]&.strip

      services_cn = row["服务范围"]&.strip
      services_en = row["SERVICES"]&.strip

      team_cn = row["设计团队"]&.strip
      team_en = row["TEAM"]&.strip

      cooperation_cn = row["合作单位"]&.strip
      cooperation_en = row["COOPERATION"]&.strip

      awards_cn = row["获奖"]&.strip
      awards_en = row["AWARDS"]&.strip

      I18n.locale = :cn

      work = Work.find_or_create_by(project_name: project_name_cn) do |w|
        w.project_name = project_name_cn
      end

      work.client = client_cn
      work.services = services_cn
      work.team = team_cn
      work.cooperation = cooperation_cn
      work.awards = awards_cn

      work.design_completion = Date.ordinal(design_completion.to_i)
      work.construction_completion = Date.ordinal(design_completion.to_i)
      work.site_area = site_area.to_i
      work.planning_area = planning_area.to_i
      work.architecture_area = architecture_area.to_i

      city = City.find_by(name: city_name)
      city = City.create(name: city_name, china_area_name: china_area_name, url_name: location.downcase) if city.blank?
      work.city_id = city.id

      I18n.locale = :en

      work.project_name = project_name_en
      work.client = client_en
      work.services = services_en
      work.team = team_en
      work.cooperation = cooperation_en
      work.awards = awards_en
      work.save

      category_names.each do |category_name|
        pt = ProjectType.find_by!(cn_name: category_name)
        WorkProjectType.find_or_create_by!(work_id: work.id, project_type_id: pt.id)
      end
    end
  end
end
