require 'rails_helper'
require './spec/support/helpers.rb'

describe ApplicationController, :type => :controller do
  
  def sign_in(user)
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end
  end
  
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
    @app_controller = ApplicationController.new()
    # @app_controller.twitter_client = @test_twitter_client
    # @app_controller.facebook_client = @test_facebook_client
    # @app_controller.mastodon_client = @test_mastodon_client
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@test_user)
    allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
    allow(@test_user).to receive(:facebook_client).and_return(@test_facebook_client)
    allow(@test_user).to receive(:mastodon_client).and_return(@test_mastodon_client)
    sign_in(@test_user)
  end
  
  describe '#req_favorite' do
    it 'calls favorite method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:favorite).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:favorite).with('1', 'provider')
      post :req_favorite, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_unfavorite' do
    it 'calls unfavorite method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:unfavorite).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:unfavorite).with('1', 'provider')
      post :req_unfavorite, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_repost' do
    it 'calls repost method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:repost).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:repost).with('1', 'provider')
      post :req_repost, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_unrepost' do
    it 'calls unrepost method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:unrepost).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:unrepost).with('1', 'provider')
      post :req_unrepost, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_archive_post' do
    it 'calls archive_post method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:archive_post).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:archive_post).with('1', 'provider')
      post :req_archive_post, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_unarchive_post' do
    it 'calls unarchive_post method and returns success' do
      allow_any_instance_of(ApplicationController).to receive(:unarchive_post).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:unarchive_post).with('1', 'provider')
      post :req_unarchive_post, :params => { 
        :id => 1,
        :provider => 'provider'
      }
      expect(response).to be_successful
    end
  end
  
  describe '#req_filter_feed_search' do
    it 'calls filter_feed_search' do
      allow_any_instance_of(ApplicationController).to receive(:filter_feed_search).and_return(true)
      expect_any_instance_of(ApplicationController).to receive(:filter_feed_search).with('text')
      post :req_filter_feed_search, :params => { 
        :text_content => 'text'
      }
    end
  end
  
end
   
   