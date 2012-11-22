class CreateAsaDbs < ActiveRecord::Migration
  def change
    create_table :asa_dbs do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :asa_dbs, :email
  end
end
