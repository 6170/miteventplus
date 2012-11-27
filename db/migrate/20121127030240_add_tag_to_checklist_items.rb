class AddTagToChecklistItems < ActiveRecord::Migration
  def change
    add_column :checklist_items, :tag, :string
  end
end
