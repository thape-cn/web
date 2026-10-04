# frozen_string_literal: true

class RemoveLegacyCases < ActiveRecord::Migration[7.2]
  def change
    # Reversal recreates empty tables; restoring content requires a backup.
    remove_foreign_key :case_pictures, :cases, name: "case_pictures_case_id_fkey"

    drop_table :case_pictures, id: :bigint, default: nil do |t|
      t.bigint :case_id
      t.text :album
      t.datetime :created_at, precision: nil, null: false
      t.datetime :updated_at, precision: nil, null: false
      t.index :case_id
    end

    drop_table :cases, id: :bigint, default: nil do |t|
      t.text :title
      t.text :market
      t.text :snapshot
      t.datetime :created_at, precision: nil, null: false
      t.datetime :updated_at, precision: nil, null: false
      t.text :professional
      t.text :other
      t.bigint :position, default: 0
      t.text :seo_title
      t.text :seo_keywords
      t.text :seo_description
    end
  end
end
