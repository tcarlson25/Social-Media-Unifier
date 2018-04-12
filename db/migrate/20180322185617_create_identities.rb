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
      t.integer :post_count
      t.integer :image_post_count
      t.integer :archive_count

      t.timestamps
    end
  end
end
