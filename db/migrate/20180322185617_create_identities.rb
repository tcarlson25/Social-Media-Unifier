class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :profile_img
      t.string :uid
      t.string :token
      t.string :secret
      t.string :name
      t.string :email
      t.integer :post_count, :default => 0
      t.integer :image_post_count, :default => 0
      t.integer :like_count, :default => 0
      t.integer :repost_count, :default => 0

      t.timestamps
    end
  end
end
