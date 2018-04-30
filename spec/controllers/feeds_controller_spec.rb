require 'rails_helper'
require './spec/support/helpers.rb'

#Cases not covered here are covered in Cucumber

describe FeedsController, :type => :controller do

   def sign_in(user)
      if user.nil?
         allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
         allow_any_instance_of(FeedsController).to receive(:current_user).and_return(nil)
     else
         allow(request.env['warden']).to receive(:authenticate!).and_return(user)
         allow_any_instance_of(FeedsController).to receive(:current_user).and_return(user)
      end
   end

   before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
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
      @feed_controller = FeedsController.new()
      sign_in(@test_user)
      allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
      allow(@test_user).to receive(:facebook_client).and_return(@test_facebook_client)
      allow(@test_user).to receive(:mastodon_client).and_return(@test_mastodon_client)
   end
   
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Feed variables" do
            
            post = TwitterPost.new(:created_at => DateTime.now)
            twitter_posts = [post]
            
            allow(Feed).to receive(:find_or_create_from_user).and_return(@test_feed)
            #allow_any_instance_of(FeedsController).to receive(:get_tweets_from_db).and_return(twitter_posts)
            allow_any_instance_of(FeedsController).to receive(:get_posts).and_return(twitter_posts)
            allow_any_instance_of(FeedsController).to receive(:get_posts).and_return(twitter_posts)
            @feed_controller.index
            expect(@feed_controller.twitter_client).to eq(@test_twitter_client)
            expect(@feed_controller.facebook_client.access_token).to eq(@test_facebook_client.access_token)
            expect(@feed_controller.facebook_client.app_secret).to eq(@test_facebook_client.app_secret)
            expect(@feed_controller.mastodon_client).to eq(@test_mastodon_client)
            expect(@feed_controller.feed).to eq(@test_feed)
            expect(@feed_controller.twitter_posts).to eq(twitter_posts)
            
         end
      end
   end
   
   describe "GET #messages" do
      context "user is not nil" do
         it "Should set twitter_client" do
            @feed_controller.messages
            expect(@feed_controller.user).to eq(@test_user)
            expect(@feed_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   describe "GET #archives" do
      context "user is not nil" do
         it "Should set twitter_client" do
            @feed_controller.archives
            expect(@feed_controller.user).to eq(@test_user)
            expect(@feed_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   describe "GET #notifications" do
      context "user is not nil" do
         it "Should set twitter_client" do
            @feed_controller.notifications
            expect(@feed_controller.user).to eq(@test_user)
            expect(@feed_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   
   describe "POST #post" do
      before do
         allow_any_instance_of(FeedsController).to receive(:current_user).and_return(@test_user)
         allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
         allow(@test_user).to receive(:facebook_client).and_return(@test_facebook_client)
      end
      
      context "user is not nil" do
         context "No provider is checked" do
            it "doesn't post anything" do
               expect_any_instance_of(FeedsController).not_to receive(:process_image)
               expect_any_instance_of(FeedsController).not_to receive(:process_images)
               expect_any_instance_of(FeedsController).not_to receive(:process_text)
               post :post, :params => {:providers => {}}
            end
            
            it 'assigns nil to all clients' do
               post :post, :params => {:providers => {}}
               expect(@feed_controller.twitter_client).eql?(nil)
               expect(@feed_controller.facebook_client).eql?(nil)
            end
         end
         
         context "Twitter is checked" do
            it 'assigns a client to twitter' do
               allow_any_instance_of(FeedsController).to receive(:process_text).and_return({:errors => ['Successful']})
               post :post, :params => {:providers => {'Twitter' => 1}}
               expect(@feed_controller.twitter_client).eql?(@test_twitter_client)
               expect(@feed_controller.facebook_client).eql?(nil)
            end
         end
         
         context "Facebook is checked" do
            it 'assigned a client to facebook' do
               allow_any_instance_of(FeedsController).to receive(:process_text).and_return({:errors => ['Successful']})
               post :post, :params => {:providers => {'Facebook' => 1}}
               expect(@feed_controller.twitter_client).eql?(nil)
               expect(@feed_controller.facebook_client).eql?(@test_facebook_client)
            end
         end
         
         context "Any provider is checked" do
            it "posts text if no images are given" do 
               allow_any_instance_of(FeedsController).to receive(:process_text).and_return({:errors => ['Successful']})
               expect_any_instance_of(FeedsController).to receive(:process_text)
               params = { 
                  :providers => { 'Twitter' => 1 },
                  :post_content => 'test',
                  :images => []
               }
               post :post, :params => params
            end
            
            it "posts an image if only 1 image is given" do
               allow_any_instance_of(FeedsController).to receive(:process_image).and_return({:errors => ['Successful']})
               expect_any_instance_of(FeedsController).to receive(:process_image)
               image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
               params = { 
                  :providers => { 'Twitter' => 1 },
                  :post_content => 'test',
                  :images => [image]
               }
               post :post, :params => params
            end
            
            it "posts images if multiple images are given" do
               allow_any_instance_of(FeedsController).to receive(:process_images).and_return({:errors => ['Successful']})
               expect_any_instance_of(FeedsController).to receive(:process_images)
               image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
               params = { 
                  :providers => { 'Twitter' => 1 },
                  :post_content => 'test',
                  :images => [image, image]
               }
               post :post, :params => params
            end
         end
      end
   end

end
