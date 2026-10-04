# frozen_string_literal: true

class Admin::DashboardController < Admin::ApplicationController
  def show
    @counts = %w[works infos people publications].to_h { |key| [key, Admin::Resource.new(key).scope.count] }
  end
end
