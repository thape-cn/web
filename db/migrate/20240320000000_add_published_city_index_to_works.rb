class AddPublishedCityIndexToWorks < ActiveRecord::Migration[7.1]
  def change
    add_index :works, [:published, :city_id], name: "index_works_on_published_and_city_id"
  end
end
