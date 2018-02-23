require 'rails_helper'

RSpec.describe User, :type => :model do
    subject { described_class.new(name: "Name", uid: "uid", provider: "Provider",
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
end
