class AddEventIdToTimeBlock < ActiveRecord::Migration
  def change
    add_column :time_blocks, :event_id, :integer
  end
end
