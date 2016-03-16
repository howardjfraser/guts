class RenameStatusUpdateTable < ActiveRecord::Migration
  def change
    rename_table :status_updates, :updates
  end
end
