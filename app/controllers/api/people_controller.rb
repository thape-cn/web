# frozen_string_literal: true

class Api::PeopleController < ApplicationController
  def index
    @people = Person.where(leaving_date: nil).order(position: :asc)
  end
end
