class WorksController < ApplicationController
  def index
  end

  def show
  end

  def demonstration_zone
    @project_type = ProjectType.find_by cn_name: '展示区/示范区'
    @self_path = demonstration_zone_works_path
    render_project_type
  end

  def residential
  end

  def residential_residence
    @residential_type = ResidentialType.find_by cn_name: '精品住宅'
    @self_path = residential_residence_works_path
    render_residential
  end

  def residential_community
    @residential_type = ResidentialType.find_by cn_name: '综合社区'
    @self_path = residential_community_works_path
    render_residential
  end

  def residential_rental
    @residential_type = ResidentialType.find_by cn_name: '租赁住房'
    @self_path = residential_rental_works_path
    render_residential
  end

  private

  def render_residential
    @works = Work.includes(:work_residential_types, work_project_types: :project_type)
      .where(work_project_types: { project_types: { cn_name: '居住' } })
      .where(work_residential_types: { residential_type_id: @residential_type.id })
    render :residential_detail
  end

  def render_project_type
    @works = Work.includes(:work_project_types)
      .where(work_project_types: { project_type_id: @project_type.id })
    render :works_detail
  end
end
