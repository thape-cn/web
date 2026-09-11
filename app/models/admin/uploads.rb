# frozen_string_literal: true

module Admin::Uploads
  extend ActiveSupport::Concern

  class_methods do
    # Namespaced models must keep the paths already used by the public models.
    def preserve_upload_paths
      uploaders.each do |attribute, uploader|
        mount_uploader attribute, Class.new(uploader) {
          def store_dir
            "uploads/#{model.class.table_name.singularize}/#{mounted_as}/#{model.id}"
          end
        }
      end
    end
  end
end
