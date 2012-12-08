class ChangeAssociationBetweenUserAndTag < ActiveRecord::Migration
  def change
    drop_table :tags_users
    add_column :tags, :user_id, :integer
  end
end
