class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :code
      t.boolean :desired_state
      t.boolean :actual_state
      
      t.timestamps
    end
  end
end
