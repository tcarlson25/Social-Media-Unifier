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
      @test_twitter_client = @test_user.twitter_client
      @settings_controller = SettingsController.new()
      allow(@test_user).to receive(:twitter_client).and_return(@test_twitter_client)
      sign_in(@test_user)
   end
   
   describe "GET #index" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.index
            expect(@settings_controller.user).to eq(@test_user)
            expect(@settings_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   describe "GET #metrics" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.metrics
            expect(@settings_controller.user).to eq(@test_user)
            expect(@settings_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   describe "GET #custom_friends" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.custom_friends
            expect(@settings_controller.user).to eq(@test_user)
            expect(@settings_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   describe "GET #accounts" do
      context "user is not nil" do
         it "Should initialize Settings client" do
            @settings_controller.accounts
            expect(@settings_controller.user).to eq(@test_user)
            expect(@settings_controller.twitter_client).to eq(@test_twitter_client)
         end
      end
   end
   
   
end
