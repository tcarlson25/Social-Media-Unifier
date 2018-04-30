require 'rails_helper'

#Cases not covered here are covered in Cucumber

RSpec.describe SettingsController, type: :controller do
   
   def sign_in(user)
      if user.nil?
         allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
         allow_any_instance_of(SettingsController).to receive(:current_user).and_return(nil)
      else
         allow(request.env['warden']).to receive(:authenticate!).and_return(user)
         allow_any_instance_of(SettingsController).to receive(:current_user).and_return(user)
      end
   end
   
    before do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      @test_user = create(:user)
      @test_twitter_client = Twitter::REST::Client.new do |config|
         config.consumer_key        = ENV['TWITTER_KEY']
         config.consumer_secret     = ENV['TWITTER_SECRET']
         config.access_token        = @test_user.twitter.token
         config.access_token_secret = @test_user.twitter.secret
      end
      @test_facebook_client = Koala::Facebook::API.new(@test_user.facebook.token)
      @settings_controller = SettingsController.new()
      allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
      allow(@test_user).to receive(:facebook_client).and_return(@test_facebook_client)
      allow_any_instance_of(SettingsController).to receive(:current_user).and_return(@test_user)
      sign_in(@test_user)
   end
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.index
            expect(@settings_controller.user).to eq(@test_user)
         end
      end
   end
   
   describe "GET #metrics" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.metrics
            expect(@settings_controller.user).to eq(@test_user)
         end
         
         it 'populates metrics hashes' do
            @settings_controller.metrics
            expect(@settings_controller.twitter_metrics.size).to eql(5)
            expect(@settings_controller.facebook_metrics.size).to eql(5)
            expect(@settings_controller.mastodon_metrics.size).to eql(5)
         end
      end
   end
   
   describe "GET #custom_friends" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.custom_friends
            expect(@settings_controller.user).to eq(@test_user)
         end
      end
   end
   
   describe "GET #accounts" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.accounts
            expect(@settings_controller.user).to eq(@test_user)
         end
      end
   end
   
   describe "POST #logout" do
      context "user is not nil" do
         it "logs out successfully" do
            expect(@test_user).to receive(:delete_identity).with('provider')
            post :logout, :params => { 
              :provider => 'provider'
            }
         end
      end
   end
   
end
