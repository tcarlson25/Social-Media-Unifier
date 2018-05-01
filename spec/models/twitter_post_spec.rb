require 'rails_helper'

RSpec.describe TwitterPost, type: :model do

  describe "#archive" do
    it "creates a TwitterPost object from post data" do
      time_stamp = DateTime.now.to_s
      twitter_post = Twitter::Tweet.new({
        :id => 1,
        :favorite_count => 3,
        :retweet_count => 2,
        :favorited => true,
        :retweeted => true,
        :created_at => time_stamp
      })
      allow(twitter_post).to receive_message_chain(:user, :name).and_return('user_name')
      allow(twitter_post).to receive_message_chain(:user, :screen_name).and_return('user_screen_name')
      allow(twitter_post).to receive_message_chain(:user, :profile_image_url).and_return('user_profile_image_url')
      allow(twitter_post).to receive(:media).and_return([])
      allow(twitter_post).to receive(:attrs).and_return({:full_text => 'post_content'})
      returned_post = TwitterPost.archive(twitter_post)
      expect(returned_post.id).to eql('1')
      expect(returned_post.name).to eql('user_name')
      expect(returned_post.username).to eql('user_screen_name')
      expect(returned_post.content).to eql('post_content')
      expect(returned_post.profile_img).to eql('user_profile_image_url')
      expect(returned_post.favorite_count).to eql(3)
      expect(returned_post.retweet_count).to eql(2)
      expect(returned_post.post_made_at).to eql(twitter_post.created_at.to_s)
      expect(returned_post.favorited?).to eql(true)
      expect(returned_post.retweeted?).to eql(true)
    end
  end
  
end
