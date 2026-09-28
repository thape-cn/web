# frozen_string_literal: true

class AddResidentialCategoryImagesToWorkTypePages < ActiveRecord::Migration[7.2]
  def change
    add_column :work_type_pages, :residential_residence_jpg, :text
    add_column :work_type_pages, :residential_community_jpg, :text
    add_column :work_type_pages, :residential_rental_jpg, :text
  end
end
