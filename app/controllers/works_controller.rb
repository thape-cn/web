class WorksController < ApplicationController
  def index
  end

  def residential
  end

  def show
  end

  def residential_rental
    @works = Work.includes(work_project_types: :project_type, work_residential_types: :residential_type)
      .where(work_project_types: { project_types: { cn_name: '居住' } })
      .where(work_residential_types: { residential_types: { cn_name: '租赁住房' } })
  end
end
