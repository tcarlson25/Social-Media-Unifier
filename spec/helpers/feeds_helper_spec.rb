require 'rails_helper'
require './spec/support/helpers'

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe FeedsHelper, type: :helper do
  
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
  
  describe "validate_twitter_response" do
    it "correctly identifies an invalid twitter response" do
      expect(validate_twitter_response(nil)).to eq('Error posting tweet')
    end
    
    it "correctly identifies a valid twitter response" do
      expect(validate_twitter_response('valid')).to eq('Successfully posted!')
    end
  end
  
  describe "process_text" do
    it "correclty identifies an empty tweet" do
      expect(process_text('')).to eq('You cannot post an empty tweet')
      expect(process_text(' ')).to eq('You cannot post an empty tweet')
    end
    
    it "posts successfully when text is not empty" do 
      returnStatus = 'Successful'
      allow(@client).to receive(:update).and_return(returnStatus)
      expect(@client).to receive(:update)
      response = process_text('test post')
      expect(response).to eq(returnStatus)
    end
  end
  
  describe "process_image" do
    it "successfully posts with one image" do
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      allow(image).to receive(:original_filename).and_return('test_image.png')
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@client).to receive(:update_with_media).and_return(returnStatus)
      response = process_image(image)
      expect(response).to eq(returnStatus)
    end
  end
  
  describe "process_images" do 
    before do
      @image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      @images = []
      allow(@image).to receive(:original_filename).and_return('test_image')
    end
    
    it "successfully posts with no more than 4 images" do
      2.times do
        @images << @image
      end
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@client).to receive(:update_with_media).and_return(returnStatus)
      response = process_images(@images)
      expect(response).to eq(returnStatus)
    end
    
    it "fails to post more than 4 images" do
      5.times do 
        @images << @image
      end
      expect(process_images(@images)).to eq('Do not upload more than 4 images at once')
    end
  end
  
end
