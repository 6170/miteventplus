class ChangeNamesOfUserField < ActiveRecord::Migration
  def change
    rename_column :users, :name, :club_name
  end
end
