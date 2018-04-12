require 'rails_helper'
require './spec/support/helpers.rb'

describe ApplicationController, type: :controller do
  
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
    @app_controller.twitter_client = @test_twitter_client
    @app_controller.facebook_client = @test_facebook_client
    @app_controller.mastodon_client = @test_mastodon_client
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@test_user)
    allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
    allow(@test_user).to receive(:facebook_client).and_return(@test_facebook_client)
    allow(@test_user).to receive(:mastodon_client).and_return(@test_mastodon_client)
    sign_in(@test_user)
  end
  
  describe "#favorite" do
    it "favorites a twitter post" do 
      allow(@app_controller.twitter_client).to receive(:favorite).and_return(true)
      expect(@app_controller.twitter_client).to receive(:favorite)
      post :favorite, :params => { 
        :id => '1',
        :provider => 'tw'
      }
    end
    
    it "favorites a mastodon post" do
      allow(@app_controller.mastodon_client).to receive(:favourite).and_return(true)
      expect(@app_controller.mastodon_client).to receive(:favourite)
      post :favorite, :params => { 
        :id => '1',
        :provider => 'ma'
      }
    end
  end
  
  describe "#unfavorite" do
    it "favorites a twitter post" do 
      allow(@app_controller.twitter_client).to receive(:unfavorite).and_return(true)
      expect(@app_controller.twitter_client).to receive(:unfavorite)
      post :unfavorite, :params => { 
        :id => '1',
        :provider => 'tw'
      }
    end
    
    it "favorites a mastodon post" do
      allow(@app_controller.mastodon_client).to receive(:unfavourite).and_return(true)
      expect(@app_controller.mastodon_client).to receive(:unfavourite)
      post :unfavorite, :params => { 
        :id => '1',
        :provider => 'ma'
      }
    end
  end
  
  describe "#repost" do
    it "favorites a twitter post" do 
      allow(@app_controller.twitter_client).to receive(:retweet).and_return(true)
      expect(@app_controller.twitter_client).to receive(:retweet)
      post :repost, :params => { 
        :id => '1',
        :provider => 'tw'
      }
    end
    
    it "favorites a mastodon post" do
      allow(@app_controller.mastodon_client).to receive(:reblog).and_return(true)
      expect(@app_controller.mastodon_client).to receive(:reblog)
      post :repost, :params => { 
        :id => '1',
        :provider => 'ma'
      }
    end
  end
  
  describe "#unrepost" do
    it "unfavorites a twitter post" do 
      allow(@app_controller.twitter_client).to receive(:unretweet).and_return(true)
      expect(@app_controller.twitter_client).to receive(:unretweet)
      post :unrepost, :params => { 
        :id => '1',
        :provider => 'tw'
      }
    end
    
    it "unfavorites a mastodon post" do
      allow(@app_controller.mastodon_client).to receive(:unreblog).and_return(true)
      expect(@app_controller.mastodon_client).to receive(:unreblog)
      post :unrepost, :params => { 
        :id => '1',
        :provider => 'ma'
      }
    end
  end
  
  describe "#archive_post" do
    it "saves a twitter post" do
      test = build(:twitter_post, feed: @test_feed)
      TwitterPost.archive(test)
      test_post = TwitterPost.first
      expect(test_post.id).to eq("123456789")
    end
  
    it "saves a mastodon post" do
      
    end
  end

   
  describe "validate_responses" do
    it "correctly identifies invalid twitter response, valid facebook response, and valid mastodon response" do
      expect(@app_controller.validate_responses(nil, 'valid', 'valid')).to eq({:errors => ['Could not post to Twitter.']})
    end
    
    it "correctly identifies valid twitter response and valid facebook response and valid mastodon response" do
      expect(@app_controller.validate_responses('valid', 'valid', 'valid')).to eq({:errors => ['Posted Successfully!']})
    end
    
    it "correctly identifies a valid twitter response and invalid facebook response and valid mastodon response" do
      expect(@app_controller.validate_responses('valid', nil, 'valid')).to eq({:errors => ['Could not post to Facebook.']})
    end
    
    it "correctly identifies a invalid twitter response and invalid facebook response and invalid mastodon response" do
      expect(@app_controller.validate_responses(nil, nil, nil)).to eq({:errors => ['Could not post to Twitter.', 'Could not post to Facebook.', 'Could not post to Mastodon.']})
    end
  end
  
  describe "get_posts" do
      it "gets twitter posts successfully" do
        returnBody = "[:body => 'test']"
        allow(@app_controller.twitter_client).to receive(:home_timeline).and_return(returnBody)
        expect(@app_controller.twitter_client).to receive(:home_timeline)
        response = @app_controller.get_posts('Twitter')
        expect(response).to eq(returnBody)
      end
      
      it "gets mastodon posts successfully" do
        returnBody = "[:body => 'test']"
        allow(@app_controller.mastodon_client).to receive(:home_timeline).and_return(returnBody)
        expect(@app_controller.mastodon_client).to receive(:home_timeline)
        response = @app_controller.get_posts('Mastodon')
        expect(response).to eq(returnBody)
      end
  end
  
  describe "process_text" do
    it "correctly identifies an empty post" do
      expect(@app_controller.process_text('')).to eq({:errors => ['You cannot make an empty post']})
      expect(@app_controller.process_text(' ')).to eq({:errors => ['You cannot make an empty post']})
    end
    
    it "posts successfully when text is not empty" do 
      returnStatus = 'Successful'
      allow(@app_controller.twitter_client).to receive(:update).and_return(returnStatus)
      allow(@app_controller.facebook_client).to receive(:put_wall_post).and_return(returnStatus)
      allow(@app_controller.mastodon_client).to receive(:create_status).and_return(returnStatus)
      expect(@app_controller.twitter_client).to receive(:update)
      expect(@app_controller.process_text('test post')).to eq({:errors => ['Posted Successfully!']})
    end
  end
  
  describe "process_image" do
    it "successfully posts with one image" do
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      allow(image).to receive(:original_filename).and_return('test_image.png')
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@app_controller.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      allow(@app_controller.facebook_client).to receive(:put_picture).and_return(returnStatus)
      
      
      #allow(@app_controller.mastodon_client).to receive(:upload_media).and_return(image)
      #allow(@app_controller.mastodon_client).to receive(:create_status).and_return(returnStatus)
      expect(@app_controller.process_image('', image)).to eq({:errors => ['Posted Successfully!']})
    end
  end
  
  describe "process_images" do 
    before do
      @image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      @images = []
      @fb_photo = {'id' => 1}
      @mastodon_photo = {'id' => 1}
      allow(@image).to receive(:original_filename).and_return('test_image')
      allow(FileUtils).to receive(:rm).and_return(true)
    end
    
    it "successfully posts with no more than 4 images" do
      2.times do
        @images << @image
      end
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      allow(@app_controller.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      allow(@app_controller.facebook_client).to receive(:put_picture).and_return(@fb_photo)
      allow(@app_controller.facebook_client).to receive(:put_connections).and_return(returnStatus)
      allow(@app_controller.mastodon_client).to receive(:upload_media).and_return(@mastodon_photo)
      allow(@app_controller.mastodon_client).to receive(:create_status).and_return(returnStatus)
      expect(@app_controller.process_images('', @images)).to eq({:errors => ['Posted Successfully!']})
    end
    
    it "fails to post more than 4 images" do
      5.times do 
        @images << @image
      end
      expect(@app_controller.process_images('', @images)).to eq({:errors => ['Do not upload more than 4 images at once']})
    end
  end
  
  
  
   
end
   
   