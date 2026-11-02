# frozen_string_literal: true

require "test_helper"
require Rails.root.join("db/migrate/20261102000000_create_tail_home_wallpapers")

class TailHomeWallpaperMigrationTest < ActiveSupport::TestCase
  test "migration backfills six complete slides for every homepage without upload callbacks" do
    connection = ActiveRecord::Base.connection
    original_path = connection.schema_search_path
    connection.execute("CREATE SCHEMA wallpaper_migration_test")
    connection.schema_search_path = "wallpaper_migration_test"
    connection.create_table(:tail_homes) do |t|
      (1..6).each do |slot|
        CreateTailHomeWallpapers::LEGACY_FIELDS.each_value { |suffix| t.string "background_#{slot}#{suffix}" }
      end
      t.timestamps
    end
    [91, 92].each do |id|
      attributes = {id: id, created_at: Time.utc(2020), updated_at: Time.utc(2021)}
      (1..6).each do |slot|
        CreateTailHomeWallpapers::LEGACY_FIELDS.each_value do |suffix|
          attributes["background_#{slot}#{suffix}"] = (id == 91) ? "#{slot} #{suffix} 中文'file.jpg" : nil
        end
      end
      columns = attributes.keys.map { |key| connection.quote_column_name(key) }.join(", ")
      values = attributes.values.map { |value| connection.quote(value) }.join(", ")
      connection.execute("INSERT INTO tail_homes (#{columns}) VALUES (#{values})")
    end
    ActiveRecord::Migration.suppress_messages { CreateTailHomeWallpapers.new.migrate(:up) }
    rows = connection.select_all("SELECT * FROM tail_home_wallpapers ORDER BY tail_home_id, position").to_a
    assert_equal 12, rows.size
    rows.each do |row|
      assert_equal row["position"], row["legacy_slot"]
      CreateTailHomeWallpapers::LEGACY_FIELDS.each do |field, suffix|
        expected = (row["tail_home_id"] == 91) ? "#{row["position"]} #{suffix} 中文'file.jpg" : nil
        expected.nil? ? assert_nil(row[field.to_s]) : assert_equal(expected, row[field.to_s])
      end
      assert_equal Time.utc(2020), row["created_at"]
      assert_equal Time.utc(2021), row["updated_at"]
    end
    assert_not connection.columns(:tail_homes).any? { |column| column.name.start_with?("background_") }
    assert_raises(ActiveRecord::IrreversibleMigration) { CreateTailHomeWallpapers.new.down }
  ensure
    connection.schema_search_path = original_path
    connection.execute("DROP SCHEMA IF EXISTS wallpaper_migration_test CASCADE")
    connection.schema_cache.clear!
  end
end
