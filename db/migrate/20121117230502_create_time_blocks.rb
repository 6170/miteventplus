class CreateTimeBlocks < ActiveRecord::Migration
  def change
    create_table :time_blocks do |t|
      t.datetime :starttime
      t.datetime :endtime

      t.timestamps
    end
  end
end
