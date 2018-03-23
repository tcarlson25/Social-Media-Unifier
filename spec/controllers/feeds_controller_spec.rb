require 'rails_helper'

#Cases not covered here are covered in Cucumber

describe FeedsController, type: :controller do

   before do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      @user = create(:user)
      @client = Twitter::REST::Client.new do |config|
         config.consumer_key        = ENV['TWITTER_KEY']
         config.consumer_secret     = ENV['TWITTER_SECRET']
         config.access_token        = @user.token
         config.access_token_secret = @user.secret
      end
   end
   
   describe "GET #get_tweets" do
      it "gets tweets successfully" do
         returnBody = "[:body => 'test']"
         allow(@client).to receive(:home_timeline).and_return(returnBody)
         expect(@client).to receive(:home_timeline)
         testFeed = FeedsController.new()
         testFeed.client = @client
         response = testFeed.get_tweets()
         expect(response).to eq returnBody
      end
   end
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Feed variables" do
            return_posts = "Twitter Posts"
            return_feed = "User Feed"
            
            testFeed = FeedsController.new()
            allow(testFeed).to receive(:current_user).and_return(@user)
            allow(testFeed).to receive(:current_client).and_return(@client)
            allow(testFeed).to receive(:get_tweets_from_db).and_return(return_posts)
            allow(@user).to receive(:feed).and_return(return_feed)
            
            response = testFeed.index
            expect(testFeed.user).to eq(@user)
            expect(testFeed.client).to eq(@client)
            expect(testFeed.feed).to eq(return_feed)
            expect(testFeed.twitter_posts).to eq(return_posts)
            
         end
      end
   end
   
   describe "GET #messages" do
      context "user is not nil" do
         it "Should set client" do
            testFeed = FeedsController.new()
            allow(testFeed).to receive(:current_user).and_return(@user)
            allow(testFeed).to receive(:current_client).and_return(@client)
            
            response = testFeed.messages
            expect(testFeed.user).to eq(@user)
            expect(testFeed.client).to eq(@client)
         end
      end
   end
   
   describe "GET #archives" do
      context "user is not nil" do
         it "Should set client" do
            testFeed = FeedsController.new()
            allow(testFeed).to receive(:current_user).and_return(@user)
            allow(testFeed).to receive(:current_client).and_return(@client)
            
            response = testFeed.archives
            expect(testFeed.user).to eq(@user)
            expect(testFeed.client).to eq(@client)
         end
      end
   end
   
   describe "GET #notifications" do
      context "user is not nil" do
         it "Should set client" do
            testFeed = FeedsController.new()
            allow(testFeed).to receive(:current_user).and_return(@user)
            allow(testFeed).to receive(:current_client).and_return(@client)
            
            response = testFeed.notifications
            expect(testFeed.user).to eq(@user)
            expect(testFeed.client).to eq(@client)
         end
      end
   end
   
   
   describe "POST #post" do
      before do
         allow_any_instance_of(FeedsController).to receive(:current_user).and_return(@user)
         allow_any_instance_of(FeedsController).to receive(:current_client).and_return(@client)
      end
      
      context "user is not nil" do
         context "No provider is checked"
            it "doesn't post anything" do
               expect_any_instance_of(FeedsController).not_to receive(:process_image)
               post :post, :params => {:providers => {}}
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
