class CreateTwitterPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :twitter_posts, id: false do |t|
      t.belongs_to :feed, index: true
      t.string :id, primary_key: true
      t.string :name
      t.string :user_name
      t.text :content
      t.string :imgurl, :null => true
      t.string :favorite_count
      t.string :retweet_count
      t.string :post_made_at
      
      t.timestamps
    end
  end
end
