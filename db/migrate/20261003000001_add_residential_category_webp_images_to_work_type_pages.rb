# frozen_string_literal: true

class AddResidentialCategoryWebpImagesToWorkTypePages < ActiveRecord::Migration[7.2]
  def change
    add_column :work_type_pages, :residential_residence_webp, :text
    add_column :work_type_pages, :residential_community_webp, :text
    add_column :work_type_pages, :residential_rental_webp, :text
  end
end
