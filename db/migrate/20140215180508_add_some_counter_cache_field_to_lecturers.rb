class AddSomeCounterCacheFieldToLecturers < ActiveRecord::Migration
  def change
    add_column :lecturers, :supervisors_pkl_count, :integer, null: false, default: 0
    add_column :lecturers, :supervisors_skripsi_count, :integer, null: false, default: 0
  end
end
