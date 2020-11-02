class WorksController < ApplicationController
  def index
    @project_type = {}
    @self_path = works_path
    if params[:q].present?
      @works = works_query_scope(params[:q]).where(published: true).page(params[:page]).per(params[:per_page])
      render :search_detail
    else
      @work_type_page = WorkTypePage.first
    end
  end

  def show
    @city = City.find_by url_name: params[:id]
    if @city.present?
      @seo.home_title = "#{@city.name}建筑设计公司-建筑设计院-建筑设计案例-天华建筑设计公司"
      @seo.description = "天华建筑#{@city.name}项目专题为您提供天华建筑的#{@city.name}建设设计、室内设计的案例，专业的#{@city.name}建设设计公司就选天华建筑有限公司。"
      @seo.abstract = @seo.description
      @seo.keywords = "#{@city.name}建筑设计公司,#{@city.name}建筑设计院,#{@city.name}建筑设计案例,#{@city.name}建筑室内设计"

      @project_type = {}
      @self_path = work_path(id: @city.url_name)
      @works = if params[:q].present?
        works_query_scope(params[:q]).where(city_id: @city.id).where(published: true)
      else
        @city.works
      end.page(params[:page]).per(params[:per_page])
      render :area_detail
    else
      @work = Work.find params[:id]

      work_project_cn_name = I18n.with_locale(:cn) { @work.project_name }
      work_project_type_names = @work.project_types.collect(&:cn_name).join('、')
      design_completion_time = if @work.design_completion_lines.present?
        @work.design_completion_lines.split("\n").join(' ')
      elsif @work.design_completion.present?
        "#{@work.design_completion.year}年"
      end
      architecture_area = if @work.architecture_area_lines.present?
        @work.architecture_area_lines.split("\n").join(' ')
      else
        "#{@work.architecture_area}㎡"
      end
      @seo.home_title = "#{work_project_cn_name}-#{work_project_type_names}设计案例-天华建筑设计公司"
      @seo.description = "#{@work.city.name}#{work_project_type_names}设计案例：#{work_project_cn_name}，设计完成时间：#{design_completion_time}，建筑面积：#{architecture_area}，设计团队：#{@work.team.split("\n").join(' ')}"
      @seo.abstract = @seo.description
      @seo.keywords = "#{work_project_cn_name}，#{work_project_type_names}设计案例"

      two_random_works = Work.pluck(:id).sample(2)
      @first_work = Work.find two_random_works[0]
      @second_work = Work.find two_random_works[1]

      work_id_in_sequence = @work.project_types.collect { |p| p.works.pluck(:id) }.flatten.uniq
      previous_work_id = if work_id_in_sequence.first == @work.id
        work_id_in_sequence.last
      else
        work_id_in_sequence[work_id_in_sequence.index(@work.id) - 1]
      end

      next_work_id = if work_id_in_sequence.last == @work.id
        work_id_in_sequence.first
      else
        work_id_in_sequence[work_id_in_sequence.index(@work.id) + 1]
      end

      @previous_work = Work.find previous_work_id
      @next_work = Work.find next_work_id

      @relative_works = Work.includes(:work_project_types)
        .where(work_project_types: { project_type_id: @work.work_project_types.pluck(:project_type_id) })
        .where.not(id: @work.id)
        .where(published: true).sample(4)
    end
  end

  def interior
    @seo = Seo.find_by seo_name: '室内设计'
    @project_type = ProjectType.find_by cn_name: '室内'
    @self_path = interior_works_path
    render_project_type
  end

  def landscape
    @seo = Seo.find_by seo_name: '景观设计'
    @project_type = ProjectType.find_by cn_name: '景观'
    @self_path = landscape_works_path
    render_project_type
  end

  def urban_planning
    @seo = Seo.find_by seo_name: '城市规划'
    @project_type = ProjectType.find_by cn_name: '城市规划'
    @self_path = urban_planning_works_path
    render_project_type
  end

  def hospitality
    @seo = Seo.find_by seo_name: '旅居/酒店'
    @project_type = ProjectType.find_by cn_name: '旅居/酒店'
    @self_path = hospitality_works_path
    render_project_type
  end

  def urban_design
    @seo = Seo.find_by seo_name: '城市设计/更新'
    @project_type = ProjectType.find_by cn_name: '城市设计/更新'
    @self_path = urban_design_works_path
    render_project_type
  end

  def medical_care
    @seo = Seo.find_by seo_name: '医疗康养'
    @project_type = ProjectType.find_by cn_name: '医疗康养'
    @self_path = education_works_path
    render_project_type
  end

  def education
    @seo = Seo.find_by seo_name: '教育设计'
    @project_type = ProjectType.find_by cn_name: '教育'
    @self_path = education_works_path
    render_project_type
  end

  def cultural
    @seo = Seo.find_by seo_name: '文化空间'
    @project_type = ProjectType.find_by cn_name: '文化空间'
    @self_path = cultural_works_path
    render_project_type
  end

  def commercial
    @seo = Seo.find_by seo_name: '商业空间'
    @project_type = ProjectType.find_by cn_name: '商业空间'
    @self_path = commercial_works_path
    render_project_type
  end

  def mixed_used_tod
    @seo = Seo.find_by seo_name: '综合体/TOD'
    @project_type = ProjectType.find_by cn_name: '综合体/TOD'
    @self_path = mixed_used_tod_works_path
    render_project_type
  end

  def supertall
    @seo = Seo.find_by seo_name: '超高层'
    @project_type = ProjectType.find_by cn_name: '超高层'
    @self_path = supertall_works_path
    render_project_type
  end

  def office
    @seo = Seo.find_by seo_name: '商务办公'
    @project_type = ProjectType.find_by cn_name: '商务办公'
    @self_path = office_works_path
    render_project_type
  end

  def demonstration_zone
    @seo = Seo.find_by seo_name: '展示区/示范区'
    @project_type = ProjectType.find_by cn_name: '展示区/示范区'
    @self_path = demonstration_zone_works_path
    render_project_type
  end

  def residential
    @seo = Seo.find_by seo_name: '居住'
    @project_type = ProjectType.find_by cn_name: '居住'
    @self_path = residential_works_path
    if params[:q].present?
      render_project_type
    end
  end

  def residential_residence
    @seo = Seo.find_by seo_name: '居住'
    @project_type = ProjectType.find_by cn_name: '居住'
    @residential_type = ResidentialType.find_by cn_name: '精品住宅'
    @self_path = residential_residence_works_path
    render_residential
  end

  def residential_community
    @seo = Seo.find_by seo_name: '居住'
    @project_type = ProjectType.find_by cn_name: '居住'
    @residential_type = ResidentialType.find_by cn_name: '综合社区'
    @self_path = residential_community_works_path
    render_residential
  end

  def residential_rental
    @seo = Seo.find_by seo_name: '居住'
    @project_type = ProjectType.find_by cn_name: '居住'
    @residential_type = ResidentialType.find_by cn_name: '租赁住房'
    @self_path = residential_rental_works_path
    render_residential
  end

  private

  def works_query_scope(q)
    Work.where('work_translations.project_name LIKE ?', "%#{q}%")
      .or(Work.where('work_translations.client LIKE ?', "%#{q}%"))
      .or(Work.where('work_translations.team LIKE ?', "%#{q}%"))
      .or(Work.where('work_translations.cooperation LIKE ?', "%#{q}%"))
      .or(Work.where('work_translations.awards LIKE ?', "%#{q}%"))
      .joins('INNER JOIN work_translations ON work_translations.work_id = works.id')
      .order(position: :asc)
      .distinct
  end

  def render_residential
    @works = if params[:q].present?
      works_query_scope(params[:q])
    else
      Work.all.order(position: :asc)
    end.includes(:work_residential_types, work_project_types: :project_type)
      .where(work_project_types: { project_types: { cn_name: '居住' } })
      .where(work_residential_types: { residential_type_id: @residential_type.id })
      .where(published: true).page(params[:page]).per(params[:per_page])
    render :residential_detail
  end

  def render_project_type
    @works = if params[:q].present?
      works_query_scope(params[:q])
    else
      Work.all.order(position: :asc)
    end.includes(:work_project_types)
      .where(work_project_types: { project_type_id: @project_type.id })
      .where(published: true).page(params[:page]).per(params[:per_page])
    render :works_detail
  end
end
