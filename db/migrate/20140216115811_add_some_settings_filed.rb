class AddSomeSettingsFiled < ActiveRecord::Migration
  def change
  	add_column :settings, :maximum_lecturer_lektor_pkl_lead, :integer, null: false, default: 0
  	add_column :settings, :maximum_lecturer_aa_pkl_lead, :integer, null: false, default: 0
  end
end
