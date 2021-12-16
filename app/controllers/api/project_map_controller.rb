# frozen_string_literal: true

class Api::ProjectMapController < ApplicationController
  def index
    @works = Work.includes(:translations).where.not(coordinate_lat: nil).where.not(coordinate_lng: nil).all
  end
end
