class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone
      t.string :vcode
      t.boolean :is_activated
      t.string :session_hash

      t.timestamps
    end
  end
end
