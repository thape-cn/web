# frozen_string_literal: true

class AddBlackHeaderToTailHomeWallpapers < ActiveRecord::Migration[7.2]
  def change
    add_column :tail_home_wallpapers, :wall_paper_need_black_header, :boolean, default: false, null: false
  end
end
