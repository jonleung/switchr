class CreateDevs < ActiveRecord::Migration
  def change
    create_table :devs do |t|
      t.string :email
      t.string :password_hash
      t.string :api_key
      t.string :api_secret

      t.timestamps
    end
  end
end
