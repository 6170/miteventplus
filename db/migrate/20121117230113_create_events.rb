class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :location
      t.references :user

      t.timestamps
    end
    add_index :events, :user_id
  end
end
