class ManagementsController < ApplicationController
  def index
    @people = Person.where(leaving_date: nil).where(category: 1)
      .order(position: :asc)
  end

  def show
    @person = Person.where(leaving_date: nil).find_by(id: params[:id]) \
      || Person.where(leaving_date: nil).find_by!(url_name: params[:id])
  end
end
