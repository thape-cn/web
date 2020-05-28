class ManagementsController < ApplicationController
  def index
    redirect_to leadership_index_path, :status => :moved_permanently
  end

  def show
    redirect_to leadership_path(id: params[:id]), :status => :moved_permanently
  end
end
