require 'rails_helper'

RSpec.describe Identity, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "find_from_auth" do
    it "Successfully creates Identity from auth hash" do
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        new_identity = Identity.find_from_auth(Rails.application.env_config["omniauth.auth"])
        expect(new_identity.provider).to eq('twitter')
        expect(new_identity.uid).to eq('12345')
        expect(new_identity.email).to eq('Test Email')
        expect(new_identity.name).to eq('Test Name')
        expect(new_identity.token).to eq('Token')
        expect(new_identity.secret).to eq('Secret')
    end
  end
end
