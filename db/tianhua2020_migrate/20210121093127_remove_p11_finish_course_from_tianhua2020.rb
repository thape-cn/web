class RemoveP11FinishCourseFromTianhua2020 < ActiveRecord::Migration[6.1]
  def change
    remove_column :tianhua2020s, :p11_finish_course, :string
    add_column :tianhua2020s, :wecom_id, :string
    add_column :tianhua2020s, :orgcode, :string
    add_column :tianhua2020s, :deptcode_sum, :string
  end
end
