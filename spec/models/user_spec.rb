require 'rails_helper'

RSpec.describe User, :type => :model do
    subject { User.new(name: "Name", uid: "uid", provider: "Provider",
    token: "Token", secret: "Secret", profile_image: "Image") }
  it "Is valid with valid attributes" do
      expect(subject).to be_valid
  end
  it "Is not vaild without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
  end
  it "Is not valid without a uid" do
      subject.uid = nil
      expect(subject).to_not be_valid
  end
  it "Is not valid without a provider" do
      subject.provider = nil
      expect(subject).to_not be_valid
  end
  it "Is not valid without a token" do
      subject.token = nil
      expect(subject).to_not be_valid
  end
  it "Is not valid without a secret" do
      subject.secret = nil
      expect(subject).to_not be_valid
  end
  it "Is not valid without a profile image" do
      subject.profile_image = nil
      expect(subject).to_not be_valid
  end
  
  before do
      #Auth hash stub
      @auth_hash_stub = OmniAuth::AuthHash.new({
            :provider => 'twitter',
            :uid => '0',
            :info => {
                :nickname => 'Stub_Name',
                :image => 'Stub_img',
            },
            :credentials => {
                :token => 'Stub_token',
                :secret => 'Stub_secret'
            }
        })
  end
  
    describe "find_or_create_from_auth_hash" do
        it "successfully creates user from auth hash" do
            new_user = User.find_or_create_from_auth_hash(@auth_hash_stub)
            expect(new_user.name).to eq('Stub_Name')
            expect(new_user.profile_image).to eq('Stub_img')
            expect(new_user.secret).to eq('Stub_secret')
            expect(new_user.token).to eq('Stub_token')
        end 
        
        it "successfully finds a user for auth hash" do
            allow(User).to receive_message_chain(:where, :first_or_create).and_return(subject)
            found_user = User.find_or_create_from_auth_hash(@auth_hash_stub)
            expect(found_user.name).to eq('Name')
            expect(found_user.profile_image).to eq('Image')
            expect(found_user.secret).to eq('Secret')
            expect(found_user.token).to eq('Token')
        end
    end 
end
