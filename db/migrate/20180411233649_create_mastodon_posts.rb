class CreateMastodonPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :mastodon_posts, id: false do |t|
      t.belongs_to :feed, index: true
      t.integer :id, primary_key: true
      t.string :content
      t.string :username
      t.string :profile_img
      t.string :imgurl
      t.boolean :favourited
      t.integer :favourites_count
      t.boolean :reblogged
      t.integer :reblogs_count
      t.string :post_made_at

      t.timestamps
    end
  end
end
