# frozen_string_literal: true

class Admin::PicturesController < Admin::ResourcesController
  def upload
    picture = Picture.new(image: params[:upload_file])
    if picture.save
      render json: {success: true, file_path: picture.image.url}
    else
      render json: {success: false, msg: picture.errors.full_messages.to_sentence}, status: :unprocessable_entity
    end
  end
end
