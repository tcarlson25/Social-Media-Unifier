require 'rails_helper'
require './spec/support/helpers.rb'

describe Users::OmniauthCallbacksController, type: :controller do
    
    before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        #allow(Identity).to receive(:find_from_auth).and_return()
    end
    
    describe "callback" do
       it "creates an identity from the auth hash" do
           @test_identity = Identity.find_from_auth(Rails.application.env_config["omniauth.auth"])
           expect(@test_identity.provider).to eq('twitter')
       end
       
       it "finds an Identity that already exists" do
           @test_user = create(:user)
           @user_identity = @test_user.twitter
           @test_identity = Identity.find_from_auth(Rails.application.env_config["omniauth.auth"])
           expect(@test_identity.provider).to eq(@user_identity.provider)
       end
    end
end