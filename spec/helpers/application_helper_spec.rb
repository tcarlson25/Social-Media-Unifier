require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    
  before do
    @test_user = create(:user)
    @test_feed = @test_user.feed
    @test_twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = @test_user.twitter.token
      config.access_token_secret = @test_user.twitter.secret
    end
    @test_facebook_client = Koala::Facebook::API.new(@test_user.facebook.token)
    @test_mastodon_client = Mastodon::REST::Client.new(base_url: 'https://mastodon.social', bearer_token: @test_user.mastodon.token)
    helper.twitter_client = @test_twitter_client
    helper.facebook_client = @test_facebook_client
    helper.mastodon_client = @test_mastodon_client
    helper.user = @test_user
  end
  
  describe '#favorite' do
    it 'favorites a twitter post' do
      allow(helper.twitter_client).to receive(:favorite).and_return(true)
      expect(helper.twitter_client).to receive(:favorite)
      helper.favorite(1, 'tw')
    end
    
    it 'favourites a mastodon post' do
      allow(helper.mastodon_client).to receive(:favourite).and_return(true)
      expect(helper.mastodon_client).to receive(:favourite)
      helper.favorite(1, 'ma')
    end
  end
  
  describe '#unfavorite' do
    it 'unfavorites a twitter post' do
      allow(helper.twitter_client).to receive(:unfavorite).and_return(true)
      expect(helper.twitter_client).to receive(:unfavorite)
      helper.unfavorite(1, 'tw')
    end
    
    it 'unfavourites a mastodon post' do
      allow(helper.mastodon_client).to receive(:unfavourite).and_return(true)
      expect(helper.mastodon_client).to receive(:unfavourite)
      helper.unfavorite(1, 'ma')
    end
  end
  
  describe '#repost' do
    it 'retweets a twitter post' do
      allow(helper.twitter_client).to receive(:retweet).and_return(true)
      expect(helper.twitter_client).to receive(:retweet)
      helper.repost(1, 'tw')
    end
    
    it 'reblogs a mastodon post' do
      allow(helper.mastodon_client).to receive(:reblog).and_return(true)
      expect(helper.mastodon_client).to receive(:reblog)
      helper.repost(1, 'ma')
    end
  end
  
  describe '#unrepost' do
    it 'unretweets a twitter post' do
      allow(helper.twitter_client).to receive(:unretweet).and_return(true)
      expect(helper.twitter_client).to receive(:unretweet)
      helper.unrepost(1, 'tw')
    end
    
    it 'unreblogs a mastodon post' do
      allow(helper.mastodon_client).to receive(:unreblog).and_return(true)
      expect(helper.mastodon_client).to receive(:unreblog)
      helper.unrepost(1, 'ma')
    end
  end
  
  describe '#archive_post' do
    before do
      allow(helper.user).to receive_message_chain(:feed, :twitter_posts, :archive).and_return(true)
      allow(helper.twitter_client).to receive(:status).and_return('APITwitterPost')
      allow(helper.user).to receive_message_chain(:feed, :mastodon_posts, :archive).and_return(true)
      allow(helper.mastodon_client).to receive(:status).and_return('APIMastodonPost')
    end
    
    it 'archives a twitter post' do
      expect(helper.twitter_client).to receive(:status)
      expect(helper.user).to receive_message_chain(:feed, :twitter_posts, :archive)
      helper.archive_post(1, 'tw')
    end
    
    it 'archives a mastodon post' do
      expect(helper.mastodon_client).to receive(:status)
      expect(helper.user).to receive_message_chain(:feed, :mastodon_posts, :archive)
      helper.archive_post(1, 'ma')
    end
  end
  
  describe '#unarchive_post' do
    before do
      allow(helper.user).to receive_message_chain(:feed, :twitter_posts, :archive, :destroy).and_return(true)
      allow(helper.twitter_client).to receive(:status).and_return('APITwitterPost')
      allow(helper.user).to receive_message_chain(:feed, :mastodon_posts, :archive, :destroy).and_return(true)
      allow(helper.twitter_client).to receive(:status).and_return('APIMastodonPost')
    end
    
    it 'unarchives a twitter post' do
      expect(helper.twitter_client).to receive(:status)
      expect(helper.user).to receive_message_chain(:feed, :twitter_posts, :archive, :destroy)
      helper.unarchive_post(1, 'tw')
    end
    
    it 'unarchives a mastodon post' do
      expect(helper.mastodon_client).to receive(:status)
      expect(helper.user).to receive_message_chain(:feed, :mastodon_posts, :archive, :destroy)
      helper.unarchive_post(1, 'ma')
    end
  end
  
  describe '#archived?' do
    it 'detects when a twitter post is archived' do
      create(:twitter_post, :id => '123', :feed_id => @test_user.feed.id)
      expect(helper.archived?('twitter', '123')).to eql(true)
    end
    
    it 'detects when a mastodon post is archived' do
      create(:mastodon_post, :id => 123, :feed_id => @test_user.feed.id)
      expect(helper.archived?('mastodon', '123')).to eql(true)
    end
    
    it 'detects when a twitter post is not archived' do
      expect(helper.archived?('twitter', '9999')).to eql(false)
    end
    
    it 'detects when a mastodon post is not archived' do
      expect(helper.archived?('mastodon', '9999')).to eql(false)
    end
  end
    
end
