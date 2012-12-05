class CreateBudgetItems < ActiveRecord::Migration
  def change
    create_table :budget_items do |t|
      t.string :title
      t.float :value
      t.integer :event_id

      t.timestamps
    end
  end
end
