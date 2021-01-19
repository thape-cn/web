class CreateFlag2020Boards < ActiveRecord::Migration[6.1]
  def change
    create_table :flag2020_boards do |t|
      t.string :from_clerkcode
      t.string :to_clerkcode
      t.text :message

      t.timestamps
    end
  end
end
