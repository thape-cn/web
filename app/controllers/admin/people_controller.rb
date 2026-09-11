# frozen_string_literal: true

class Admin::PeopleController < Admin::ResourcesController
  def destory_city_people
    person = @resource.scope.find(params[:id])
    person.city_people.find(params[:city_people_id]).destroy!
    redirect_to edit_admin_person_path(person), notice: "城市职位已删除", status: :see_other
  end
end
