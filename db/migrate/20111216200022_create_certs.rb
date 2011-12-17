class CreateCerts < ActiveRecord::Migration
  def change
    create_table :certs do |t|
      t.string :name
      t.integer :user_id
      t.integer :device_id

      t.timestamps
    end
  end
end
