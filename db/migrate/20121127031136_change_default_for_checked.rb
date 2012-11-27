class ChangeDefaultForChecked < ActiveRecord::Migration
  def change
    change_column :checklist_items, :checked, :boolean, :default => false
  end

end
