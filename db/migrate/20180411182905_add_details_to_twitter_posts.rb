class AddDetailsToTwitterPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :twitter_posts, :id_str, :string
    add_column :twitter_posts, :favorited, :boolean
    add_column :twitter_posts, :retweeted, :boolean
    change_column :twitter_posts, :favorite_count, :integer
    change_column :twitter_posts, :retweet_count, :integer
  end
end
