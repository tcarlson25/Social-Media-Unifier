require 'rails_helper'

RSpec.describe User, :type => :model do

  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
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
  end
  
  describe "#from_omniauth" do
    it "creates a user from access_token" do
      user = User.from_omniauth(Rails.application.env_config["omniauth.auth"])
      expect(user.name).to eq("Test Name")
      expect(user.email).to eq("test email")
    end
    
  end

  describe "#twitter_client" do
    it "creates a twitter client successfully" do
      allow(Twitter::REST::Client).to receive(:new).and_return(@test_twitter_client)
      allow(@test_twitter_client).to receive_message_chain(:user, :profile_image_url).and_return(true)
      expect(@test_user.twitter_client).to eq(@test_twitter_client)
    end
  end
  
  describe "#facebook_client" do
    it "creates a facebook client successfully" do
      allow(Koala::Facebook::API).to receive(:new).and_return(@test_facebook_client)
      allow(@test_facebook_client).to receive(:get_object).with('me').and_return({:id => 1})
      allow(@test_facebook_client).to receive(:get_picture).and_return(true)
      expect(@test_user.facebook_client).to eq(@test_facebook_client)
    end
  end
  
  describe "#mastodon_client" do
    it "creates a mastodon client successfully" do
      allow(Mastodon::REST::Client).to receive(:new).and_return(@test_mastodon_client)
      allow(@test_mastodon_client).to receive_message_chain(:verify_credentials, :avatar).and_return(true)
      expect(@test_user.mastodon_client).to eq(@test_mastodon_client)
    end
  end
  
  describe "#delete_identity" do
    it "destroys an identity given a provider" do
      @test_user.delete_identity('twitter')
      expect(@test_user.twitter).to be(nil)
    end
  end

end
