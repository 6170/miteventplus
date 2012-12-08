class CreatePublicityEmails < ActiveRecord::Migration
  def change
    create_table :publicity_emails do |t|
      t.text :content
      t.references :event
      t.string :subject

      t.timestamps
    end
    add_index :publicity_emails, :event_id
  end
end
