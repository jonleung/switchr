class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :password_hint
      t.string :session_hash

      t.timestamps
    end
  end
end
