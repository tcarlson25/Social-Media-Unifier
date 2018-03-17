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
         response = @client.update('Testing post')
         expect(response).to eq returnStatus
      end
   end

end
