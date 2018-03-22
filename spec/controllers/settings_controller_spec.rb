require 'rails_helper'

#Cases not covered here are covered in Cucumber

RSpec.describe SettingsController, type: :controller do
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
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            testSettings = SettingsController.new()
            allow(testSettings).to receive(:current_user).and_return(@user)
            allow(testSettings).to receive(:current_client).and_return(@client)
            
            response = testSettings.index
            expect(testSettings.user).to eq(@user)
            expect(testSettings.client).to eq(@client)
         end
      end
   end
   
   describe "GET #metrics" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            testSettings = SettingsController.new()
            allow(testSettings).to receive(:current_user).and_return(@user)
            allow(testSettings).to receive(:current_client).and_return(@client)
            
            response = testSettings.metrics
            expect(testSettings.user).to eq(@user)
            expect(testSettings.client).to eq(@client)
         end
      end
   end
   
   describe "GET #custom_friends" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            testSettings = SettingsController.new()
            allow(testSettings).to receive(:current_user).and_return(@user)
            allow(testSettings).to receive(:current_client).and_return(@client)
            
            response = testSettings.custom_friends
            expect(testSettings.user).to eq(@user)
            expect(testSettings.client).to eq(@client)
         end
      end
   end
   
   describe "GET #accounts" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            testSettings = SettingsController.new()
            allow(testSettings).to receive(:current_user).and_return(@user)
            allow(testSettings).to receive(:current_client).and_return(@client)
            
            response = testSettings.accounts
            expect(testSettings.user).to eq(@user)
            expect(testSettings.client).to eq(@client)
         end
      end
   end
   
   
end
