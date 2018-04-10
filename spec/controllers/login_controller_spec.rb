require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  
  def sign_in(user)
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow_any_instance_of(LoginController).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow_any_instance_of(LoginController).to receive(:current_user).and_return(user)
    end
  end
   
  before do 
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    @user = create(:user)
    sign_in(@user)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

end
