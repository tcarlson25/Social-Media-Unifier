require 'rails_helper'
require './spec/support/helpers.rb'

#Cases not covered here are covered in Cucumber

describe FeedsController, type: :controller do

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
      @test_twitter_client = @test_user.twitter_client
      @feed_controller = FeedsController.new()
      sign_in(@test_user)
      allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
   end
   
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Feed variables" do
            return_posts = "Twitter Posts"
            
            allow(Feed).to receive(:find_or_create_from_user).and_return(@test_feed)
            allow_any_instance_of(FeedsController).to receive(:get_tweets_from_db).and_return(return_posts)
            
            @feed_controller.index
            expect(@feed_controller.twitter_client).to eq(@test_twitter_client)
            expect(@feed_controller.feed).to eq(@test_feed)
            expect(@feed_controller.twitter_posts).to eq(return_posts)
            
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
      end
      
      context "user is not nil" do
         context "No provider is checked" do
            it "doesn't post anything" do
               expect_any_instance_of(FeedsController).not_to receive(:process_image)
               expect_any_instance_of(FeedsController).not_to receive(:process_images)
               expect_any_instance_of(FeedsController).not_to receive(:process_text)
               post :post, :params => {:providers => {}}
            end
         end
         
         context "Twitter is checked" do
            it "posts text if no images are given" do 
               allow_any_instance_of(FeedsController).to receive(:process_text).and_return('Successful')
               expect_any_instance_of(FeedsController).to receive(:process_text)
               params = { 
                  :providers => { 'Twitter' => 1 },
                  :post_content => 'test',
                  :images => []
               }
               post :post, :params => params
            end
            
            it "posts an image if only 1 image is given" do
               allow_any_instance_of(FeedsController).to receive(:process_image).and_return('Successful')
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
               allow_any_instance_of(FeedsController).to receive(:process_images).and_return('Successful')
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
