require 'csv'
require 'chinese_pinyin'

namespace :import_people do
  desc "Import the CSV to people"
  task :from_csv, [:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      序号 = row['序号']&.strip

      区域归属1 = row['区域归属1']&.strip
      区域抬头1 = row['区域抬头1']&.strip

      区域归属2 = row['区域归属2']&.strip
      区域抬头2 = row['区域抬头2']&.strip

      区域归属3 = row['区域归属3']&.strip
      区域抬头3 = row['区域抬头3']&.strip

      区域归属4 = row['区域归属4']&.strip
      区域抬头4 = row['区域抬头4']&.strip

      团队归属 = row['团队归属']&.strip

      原官网标记 = row['原官网标记']&.strip

      姓名 = row['姓名']&.strip
      抬头1 = row['抬头1']&.strip
      抬头2 = row['抬头2']&.strip
      抬头3 = row['抬头3']&.strip
      抬头4 = row['抬头4']&.strip
      抬头5 = row['抬头5']&.strip
      抬头6 = row['抬头6']&.strip
      抬头7 = row['抬头7']&.strip


      I18n.locale = :cn

      person = Person.find_or_create_by(name: 姓名) do |person|
        person.name = 姓名
        person.in_old_web = false
      end

      person.position = 序号
      name_in_url = Pinyin.t(姓名, splitter: '')
      name_in_url_count = Person.where(url_name: name_in_url).where.not(name: 姓名).count()

      name_in_url = "#{name_in_url}#{name_in_url_count}" unless name_in_url_count.zero?
      person.url_name = name_in_url
      save_success = person.save
      byebug unless save_success

      update_city_people_title(person, 区域归属1, 区域抬头1)
      update_city_people_title(person, 区域归属2, 区域抬头2)
      update_city_people_title(person, 区域归属3, 区域抬头3)
      update_city_people_title(person, 区域归属4, 区域抬头4)

      if 团队归属 == '管理'
        person.category = 1
      else
        person.category = 2
      end

      抬头 = [抬头1, 抬头2, 抬头3, 抬头4, 抬头5, 抬头6, 抬头7].reject(&:blank?)
      person.title = 抬头.join("\n")
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
  task :update_position,[:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      序号 = row['序号']&.strip

      团队 = row['团队']&.strip
      姓名 = row['姓名']&.strip
      person = Person.find_by name: 姓名
      person.update(position: 序号)
    end
  end

  desc "Update the people English name and title"
  task :update_en_title,[:csv_file] => [:environment] do |task, args|
    csv_file_path = args[:csv_file]
    CSV.foreach(csv_file_path, headers: true) do |row|
      序号 = row['序号']&.strip

      团队 = row['团队']&.strip
      姓名 = row['姓名']&.strip
      name = row['NAME']&.strip
      I18n.locale = :cn
      person = Person.find_by name: 姓名
      I18n.locale = :en
      person.update(name: name)

      抬头1 = row['抬头1']&.strip
      title_1 = row['TITLE 1']&.strip
      update_city_en_title(person, 抬头1, title_1) if 抬头1.present?
      抬头2 = row['抬头2']&.strip
      title_2 = row['TITLE 2']&.strip
      update_city_en_title(person, 抬头2, title_2) if 抬头2.present?

      抬头3 = row['抬头3']&.strip
      title_3 = row['TITLE 3']&.strip
      update_city_en_title(person, 抬头3, title_3) if 抬头3.present?

      抬头4 = row['抬头4']&.strip
      title_4 = row['TITLE 4']&.strip
      update_city_en_title(person, 抬头4, title_4) if 抬头4.present?

      抬头5 = row['抬头5']&.strip
      title_5 = row['TITLE 5']&.strip
      update_city_en_title(person, 抬头5, title_5) if 抬头5.present?
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
