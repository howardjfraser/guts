class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.text :message
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
