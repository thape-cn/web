# frozen_string_literal: true

class Admin::PictureUsage
  Usage = Data.define(:resource, :record, :field, :locale, :association)

  def call(pictures)
    pictures = pictures.to_a
    usages = pictures.to_h { |picture| [picture.id, []] }
    references = PictureReference.where(picture_id: usages.keys).order(:owner_type, :owner_id, :field, :locale)
    resources = Admin::Resource.all.index_by { |resource| resource.model.base_class.name }
    references.group_by(&:owner_type).each do |type, group|
      resource = resources.fetch(type)
      records = resource.model.unscoped.where(id: group.map(&:owner_id))
      records = records.includes(:translations) if resource.model.respond_to?(:translated_attribute_names)
      owners = records.index_by(&:id)
      group.each do |reference|
        record = owners[reference.owner_id]
        next unless record

        usages[reference.picture_id] << Usage.new(resource, record, reference.field, reference.locale.presence, false)
      end
    end
    add_news_associations(pictures, usages)
    usages
  end

  private

  def add_news_associations(pictures, usages)
    news = Admin::Info.unscoped.where(id: pictures.filter_map(&:info_id)).index_by(&:id)
    resource = Admin::Resource.new("infos")
    pictures.each do |picture|
      record = news[picture.info_id]
      next unless record
      next if usages[picture.id].any? { |usage| usage.resource.key == "infos" && usage.record.id == record.id }

      usages[picture.id] << Usage.new(resource, record, nil, nil, true)
    end
  end
end
