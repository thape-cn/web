# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @tail_home = TailHome.includes(:wallpapers, work_1: :project_types, work_2: :project_types, work_3: :project_types, work_4: :project_types, work_5: :project_types, work_6: :project_types).first
    @wallpapers = @tail_home.wallpapers
  end
end
