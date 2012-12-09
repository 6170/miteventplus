class RemoveLocation < ActiveRecord::Migration
  def change
  	remove_column :events, :location
  end

end
