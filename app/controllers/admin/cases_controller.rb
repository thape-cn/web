# frozen_string_literal: true

class Admin::CasesController < Admin::ResourcesController
  def destory_picture
    record = @resource.scope.find(params[:id])
    record.case_pictures.find(params[:picture_id]).destroy!
    redirect_to edit_admin_case_path(record), notice: "图片已删除", status: :see_other
  end
end
