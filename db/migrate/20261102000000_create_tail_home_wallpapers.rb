# frozen_string_literal: true

class CreateTailHomeWallpapers < ActiveRecord::Migration[7.2]
  LEGACY_FIELDS = {
    title: "_title", subtitle: "_subtitle", link: "_link",
    image: "", image_webp: "_webp", mobile_image: "_mobile",
    mobile_image_webp: "_mobile_webp", tablet_image: "_pad", tablet_image_webp: "_pad_webp"
  }.freeze

  def up
    create_table :tail_home_wallpapers do |t|
      t.references :tail_home, null: false, foreign_key: true
      t.integer :position, null: false
      # The original storage directory must not change when slides are reordered.
      t.integer :legacy_slot
      LEGACY_FIELDS.each_key { |field| t.string field }
      t.timestamps
      t.index [:tail_home_id, :position]
      t.index [:tail_home_id, :legacy_slot], unique: true
      t.check_constraint "position BETWEEN 1 AND 10", name: "tail_home_wallpaper_position"
      t.check_constraint "legacy_slot BETWEEN 1 AND 6", name: "tail_home_wallpaper_legacy_slot"
    end

    # Copy identifiers directly: no application callbacks, uploads or remote I/O.
    (1..6).each do |slot|
      execute <<~SQL
        INSERT INTO tail_home_wallpapers
          (tail_home_id, position, legacy_slot, #{LEGACY_FIELDS.keys.join(", ")}, created_at, updated_at)
        SELECT id, #{slot}, #{slot},
          #{LEGACY_FIELDS.values.map { |suffix| "background_#{slot}#{suffix}" }.join(", ")}, created_at, updated_at
        FROM tail_homes
      SQL
    end

    columns = (1..6).flat_map { |slot| LEGACY_FIELDS.values.map { |suffix| "background_#{slot}#{suffix}" } }
    remove_columns :tail_homes, *columns
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "A variable carousel cannot be restored to six fixed slots without losing slides."
  end
end
