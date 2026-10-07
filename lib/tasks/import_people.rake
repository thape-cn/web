# frozen_string_literal: true

require "csv"
require "chinese_pinyin"

namespace :import_people do
  desc "Import the CSV to people"
  task :from_csv, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      sequence_number = row["序号"]&.strip

      region_1 = row["区域归属1"]&.strip
      region_title_1 = row["区域抬头1"]&.strip

      region_2 = row["区域归属2"]&.strip
      region_title_2 = row["区域抬头2"]&.strip

      region_3 = row["区域归属3"]&.strip
      region_title_3 = row["区域抬头3"]&.strip

      region_4 = row["区域归属4"]&.strip
      region_title_4 = row["区域抬头4"]&.strip

      team_affiliation = row["团队归属"]&.strip

      name = row["姓名"]&.strip
      title_1 = row["抬头1"]&.strip
      title_2 = row["抬头2"]&.strip
      title_3 = row["抬头3"]&.strip
      title_4 = row["抬头4"]&.strip
      title_5 = row["抬头5"]&.strip
      title_6 = row["抬头6"]&.strip
      title_7 = row["抬头7"]&.strip

      I18n.locale = :cn

      person = Person.find_or_create_by(name: name) do |p|
        p.name = name
        p.in_old_web = false
      end

      person.position = sequence_number
      name_in_url = Pinyin.t(name, splitter: "")
      name_in_url_count = Person.where(url_name: name_in_url).where.not(name: name).count

      name_in_url = "#{name_in_url}#{name_in_url_count}" unless name_in_url_count.zero?
      person.url_name = name_in_url
      person.save!

      update_city_people_title(person, region_1, region_title_1)
      update_city_people_title(person, region_2, region_title_2)
      update_city_people_title(person, region_3, region_title_3)
      update_city_people_title(person, region_4, region_title_4)

      person.category = if team_affiliation == "管理"
        1
      else
        2
      end

      titles = [title_1, title_2, title_3, title_4, title_5, title_6, title_7].reject(&:blank?)
      person.title = titles.join("\n")
      person.save!
    end
  end

  def update_city_people_title(person, city_name, city_title)
    city1 = City.find_by(name: city_name)
    return if city1.blank? || city_title.blank?

    person_city = person.city_people.find_or_create_by(city_id: city1.id) do |city_people|
      city_people.city_title = city_title
    end
    person_city.update(city_title: city_title)
  end

  desc "Update the people position"
  task :update_position, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      sequence_number = row["序号"]&.strip

      name = row["姓名"]&.strip
      person = Person.find_by name: name
      person.update(position: sequence_number)
    end
  end

  desc "Update the people English name and title"
  task :update_en_title, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      cn_name = row["姓名"]&.strip
      name = row["NAME"]&.strip
      I18n.locale = :cn
      person = Person.find_by name: cn_name
      I18n.locale = :en
      person.update(name: name)

      city_title_1 = row["抬头1"]&.strip
      title_1 = row["TITLE 1"]&.strip
      update_city_en_title(person, city_title_1, title_1) if city_title_1.present?
      city_title_2 = row["抬头2"]&.strip
      title_2 = row["TITLE 2"]&.strip
      update_city_en_title(person, city_title_2, title_2) if city_title_2.present?

      city_title_3 = row["抬头3"]&.strip
      title_3 = row["TITLE 3"]&.strip
      update_city_en_title(person, city_title_3, title_3) if city_title_3.present?

      city_title_4 = row["抬头4"]&.strip
      title_4 = row["TITLE 4"]&.strip
      update_city_en_title(person, city_title_4, title_4) if city_title_4.present?

      city_title_5 = row["抬头5"]&.strip
      title_5 = row["TITLE 5"]&.strip
      update_city_en_title(person, city_title_5, title_5) if city_title_5.present?
    end
  end

  def update_city_en_title(person, city_title, city_en_title)
    city_person = person.city_people.find_by(city_title: city_title)
    if city_person.present?
      city_person.update(city_en_title: city_en_title)
    else
      person.update(title: city_en_title)
    end
  end
end
