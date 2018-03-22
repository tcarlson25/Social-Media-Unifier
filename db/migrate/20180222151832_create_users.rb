class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uid
      t.string :provider
      t.string :token
      t.string :secret
      # t.string :encrypted_token
      # t.string :encrypted_token_iv
      # t.string :encrypted_secret
      # t.string :encrypted_secret_iv
  
      t.timestamps
    end
  end
end
