require 'rails_helper'

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

   describe "POST #post_tweet" do
      it "posts successfully" do
         returnStatus = 'Successfull'
         allow(@client).to receive(:update).and_return(returnStatus)
         expect(@client).to receive(:update)
         testFeed = FeedsController.new()
         testFeed.set_client(@client)
         response = testFeed.post_tweet('test post')
         expect(response).to eq returnStatus
      end
   end
   
   describe "GET #get_tweets" do
      it "gets tweets successfully" do
         returnBody = "[:body => 'test']"
         allow(@client).to receive(:home_timeline).and_return(returnBody)
         expect(@client).to receive(:home_timeline)
         testFeed = FeedsController.new()
         testFeed.set_client(@client)
         response = testFeed.get_tweets_with_api()
         expect(response).to eq returnBody
      end
   end

end
