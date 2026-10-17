# frozen_string_literal: true

class Admin::PicturesController < Admin::ResourcesController
  def show
    @picture_usages = Admin::PictureUsage.new.call([@record])
    response.headers["Cache-Control"] = "no-store"
    if request.xhr?
      render partial: "admin/pictures/details", locals: {picture: @record}
    else
      render "admin/pictures/show"
    end
  end

  def upload
    picture = Picture.new(image: params[:upload_file])
    if picture.save
      render json: {success: true, file_path: picture.image.url}
    else
      render json: {success: false, msg: picture.errors.full_messages.to_sentence}, status: :unprocessable_entity
    end
  end

  private

  def search_records(records, query)
    query = query.strip
    matches = super
    query.match?(/\A#?\d+\z/) ? matches.or(records.where(id: query.delete_prefix("#"))) : matches
  end

  def apply_filter(records, field, value)
    case field
    when "file_type"
      extensions = (value == "jpg") ? %w[jpg jpeg] : [value]
      records.where(extensions.map { "pictures.image ILIKE ?" }.join(" OR "), *extensions.map { |extension| "%.#{extension}" })
    when "reference_status"
      references = PictureReference.select(:picture_id)
      (value == "referenced") ? records.where(id: references) : records.where.not(id: references)
    when "owner_type"
      records.where(id: PictureReference.where(owner_type: value).select(:picture_id))
    else
      super
    end
  end
end
