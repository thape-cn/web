# frozen_string_literal: true

class Admin::TailHomeWallpapersController < Admin::ResourcesController
  def edit
    if @record.new_record?
      TailHome::MIN_WALLPAPERS.times { |index| @record.wallpapers.build(position: index + 1) }
    end
    super
  end

  private

  def record_params
    images = %i[image image_webp mobile_image mobile_image_webp]
    fields = [:id, :title, :subtitle, :link, :position, :wall_paper_need_black_header, :_destroy] + images.flat_map { |field| [field, "#{field}_cache", "remove_#{field}"] }
    params.require(:tail_home).permit(wallpapers_attributes: fields).to_h
  end

  def save_record
    # Serialize collection edits so concurrent additions/removals cannot bypass the limits.
    @record.with_lock do
      @record.assign_attributes(record_params)
      @record.save!
    end
    redirect_to resource_location, notice: "保存成功", status: :see_other
  rescue ActiveRecord::RecordInvalid
    render "admin/resources/form", status: :unprocessable_entity
  end
end
