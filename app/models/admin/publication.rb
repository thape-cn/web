# frozen_string_literal: true

class Admin::Publication < ::Publication
  include Admin::Uploads

  preserve_upload_paths
  validates :category_status, presence: {message: ->(_record, _data) { I18n.t("admin.fields.category_required") }}
end
