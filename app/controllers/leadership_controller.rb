class LeadershipController < ApplicationController
  def index
    @management_people = Person.where(leaving_date: nil).where(category: 1)
      .order(position: :asc).limit(12)

    @speciality_people = Person.where(leaving_date: nil).where(category: 2)
      .order(position: :asc).limit(12)
  end

  def show
    case params[:id]
    when "shanghai"
      @management_people = Person.where(leaving_date: nil).where(category: 1).where(belong_area: '上海')
        .order(position: :asc).limit(12)

      @speciality_people = Person.where(leaving_date: nil).where(category: 2).where(belong_area: '上海')
        .order(position: :asc).limit(12)
      render 'area_leadership', locals: { c: '上海', e: 'SHANGHAI' }
    else
      @person = Person.where(leaving_date: nil).find_by(id: params[:id]) \
        || Person.where(leaving_date: nil).find_by!(url_name: params[:id])
      @infos = Info.order(position: :asc).where(hide_in_design_staff_news: false).limit(4)
      @infos = @infos.where('title LIKE ?', "%#{@person.name}%").or(@infos.where('content LIKE ?', "%#{@person.name}%"))
    end
  end
end
