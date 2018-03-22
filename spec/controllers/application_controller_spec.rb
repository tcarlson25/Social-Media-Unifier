require 'rails_helper'

describe ApplicationController, type: :controller do
    before do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      @user = create(:user)
      session[:user_id] = @user.id 
      @client = Twitter::REST::Client.new do |config|
         config.consumer_key        = ENV['TWITTER_KEY']
         config.consumer_secret     = ENV['TWITTER_SECRET']
         config.access_token        = @user.token
         config.access_token_secret = @user.secret
      end
   end
   
   describe "making #current_client" do
       it "makes the current client" do
           allow(Twitter::REST::Client).to receive(:new).and_return(@client)
           test_app = ApplicationController.new()
           response = test_app.current_client
           expect(response).to eq(@client)
           expect(response.consumer_key).to eq(ENV['TWITTER_KEY'])
           expect(response.consumer_secret).to eq(ENV['TWITTER_SECRET'])
           expect(response.access_token).to eq(@user.token)
           expect(response.access_token_secret).to eq(@user.secret)
       end
   end
   
   #describe "Finding #current_user" do
    #   it "Should find the current used based on session" do
     #      allow(User).to receive(:find).and_return(@user)
      #     test_app = ApplicationController.new()
       #    response = test_app.current_user
        #   expect(response).to eq(@user)
       #end
   #end
   
end
   
   