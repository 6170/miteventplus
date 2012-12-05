class AddSupportForGroupTags < ActiveRecord::Migration
  def change
    add_column :asa_dbs, :unprocessed_tags, :text

    create_table :tags do |t|
      t.string :name, :null => false
      t.timestamps
    end

    create_table :tags_users do |t|
      t.integer :user_id
      t.integer :tag_id
    end
  end
end
