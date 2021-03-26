# frozen_string_literal: true

class PublicationsController < ApplicationController
  def index
    @list = Publication.all
    puts @list
  end
end
