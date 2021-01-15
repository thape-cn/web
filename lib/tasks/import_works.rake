# frozen_string_literal: true

require 'csv'

namespace :import_works do
  desc 'Import the CSV to works'
  task :from_csv, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      大类别s = row['大类别'].split(',')
      小类别 = row['小类别']

      中文项目名称 = row['中文项目名称']&.strip
      英文项目名称 = row['英文项目名称']&.strip

      客户名称 = row['客户名称']&.strip
      CLIENT = row['CLIENT']&.strip

      设计完成时间 = row['设计完成时间']&.strip
      竣工时间 = row['竣工时间']&.strip

      所在城市 = row['所在城市']&.strip
      所属区域 = row['区域']&.strip
      LOCATION = row['LOCATION']&.strip

      用地面积 = row['用地面积']&.strip
      规划面积 = row['规划面积']&.strip
      建筑面积 = row['建筑面积']&.strip

      服务范围 = row['服务范围']&.strip
      SERVICES = row['SERVICES']&.strip

      设计团队 = row['设计团队']&.strip
      TEAM = row['TEAM']&.strip

      合作单位 = row['合作单位']&.strip
      COOPERATION = row['COOPERATION']&.strip

      获奖 = row['获奖']&.strip
      AWARDS = row['AWARDS']&.strip

      I18n.locale = :cn

      work = Work.find_or_create_by(project_name: 中文项目名称) do |work|
        work.project_name = 中文项目名称
      end

      work.client = 客户名称
      work.services = 服务范围
      work.team = 设计团队
      work.cooperation = 合作单位
      work.awards = 获奖


      work.design_completion = Date.ordinal(设计完成时间.to_i)
      work.construction_completion = Date.ordinal(设计完成时间.to_i)
      work.site_area = 用地面积.to_i
      work.planning_area = 规划面积.to_i
      work.architecture_area = 建筑面积.to_i

      city = City.find_by(name: 所在城市)
      city = City.create(name: 所在城市, china_area_name: 所属区域, url_name: LOCATION.downcase) if city.blank?
      work.city_id = city.id

      I18n.locale = :en

      work.project_name = 英文项目名称
      work.client = CLIENT
      work.services = SERVICES
      work.team = TEAM
      work.cooperation = COOPERATION
      work.awards = AWARDS
      work.save

      大类别s.each do |大类别|
        pt = ProjectType.find_by!(cn_name: 大类别)
        WorkProjectType.find_or_create_by!(work_id: work.id, project_type_id: pt.id)
      end
    end
  end
end
