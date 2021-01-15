class AddP10TeacherLevelToTianhua2020 < ActiveRecord::Migration[6.1]
  def change
    add_column :tianhua2020s, :p10_teacher_level, :string
  end
end
