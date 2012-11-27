class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.text :text
      t.boolean :checked, :default => true
      t.integer :event_id, :null => false

      t.timestamps
    end
  end
end
