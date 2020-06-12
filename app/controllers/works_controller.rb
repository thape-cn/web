class WorksController < ApplicationController
  def index
  end

  def show
  end

  def interior
    @project_type = ProjectType.find_by cn_name: '室内'
    @self_path = interior_works_path
    render_project_type
  end

  def landscape
    @project_type = ProjectType.find_by cn_name: '景观'
    @self_path = landscape_works_path
    render_project_type
  end

  def urban_planning
    @project_type = ProjectType.find_by cn_name: '城市规划'
    @self_path = urban_planning_works_path
    render_project_type
  end

  def hospitality
    @project_type = ProjectType.find_by cn_name: '旅居/酒店'
    @self_path = hospitality_works_path
    render_project_type
  end

  def urban_design
    @project_type = ProjectType.find_by cn_name: '城市设计/更新'
    @self_path = urban_design_works_path
    render_project_type
  end

  def medical_care
    @project_type = ProjectType.find_by cn_name: '医疗康养'
    @self_path = education_works_path
    render_project_type
  end

  def education
    @project_type = ProjectType.find_by cn_name: '教育'
    @self_path = education_works_path
    render_project_type
  end

  def cultural
    @project_type = ProjectType.find_by cn_name: '文化空间'
    @self_path = cultural_works_path
    render_project_type
  end

  def commercial
    @project_type = ProjectType.find_by cn_name: '商业空间'
    @self_path = commercial_works_path
    render_project_type
  end

  def mixed_used_tod
    @project_type = ProjectType.find_by cn_name: '综合体/TOD'
    @self_path = mixed_used_tod_works_path
    render_project_type
  end

  def supertall
    @project_type = ProjectType.find_by cn_name: '超高层'
    @self_path = supertall_works_path
    render_project_type
  end

  def office
    @project_type = ProjectType.find_by cn_name: '商务办公'
    @self_path = office_works_path
    render_project_type
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
      .where(published: true)
    render :residential_detail
  end

  def render_project_type
    @works = Work.includes(:work_project_types)
      .where(work_project_types: { project_type_id: @project_type.id })
      .where(published: true)
    render :works_detail
  end
end
