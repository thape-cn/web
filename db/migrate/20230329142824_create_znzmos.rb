class CreateZnzmos < ActiveRecord::Migration[7.0]
  def change
    create_table :znzmos do |t|
      t.string :url
      t.string :keywords
      t.string :user_id
      t.string :view_count
      t.string :download_count
      t.string :update_time
      t.string :design_date
      t.string :design_style
      t.string :file_type
      t.string :file_page_num
      t.string :designer
      t.string :developer
      t.string :project_area
      t.string :official_subsidy_price
      t.string :vip_price

      t.timestamps
    end
  end
end
