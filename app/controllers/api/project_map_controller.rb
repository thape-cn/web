# frozen_string_literal: true

class Api::ProjectMapController < ApplicationController
  def index
    @works = Work.includes(:translations).where(published: true).all
  end
end
