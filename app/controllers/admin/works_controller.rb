# frozen_string_literal: true

class Admin::WorksController < Admin::ResourcesController
  def destory_picture
    work = @resource.scope.find(params[:id])
    work.work_pictures.find(params[:work_picture_id]).destroy!
    redirect_to edit_admin_work_path(work), notice: "图片已删除", status: :see_other
  end
end
