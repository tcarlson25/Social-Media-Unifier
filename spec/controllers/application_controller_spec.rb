require 'rails_helper'
require './spec/support/helpers.rb'

describe ApplicationController, type: :controller do
  
  def sign_in(user)
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end
  end
  
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    @test_user = create(:user)
    @test_feed = @test_user.feed
    @test_twitter_client = @test_user.twitter_client
    @app_controller = ApplicationController.new()
    @app_controller.twitter_client = @test_twitter_client
  end
   
   
  describe "set_sign_in_required" do
    it "sets the correct flash notice" do
      expect(@app_controller.set_sign_in_required()).to eq('Log in with Twitter to use this application')
    end
  end
   
   
  describe "validate_twitter_response" do
    it "correctly identifies an invalid twitter response" do
      expect(@app_controller.validate_twitter_response(nil)).to eq('Error posting tweet')
    end
    
    it "correctly identifies a valid twitter response" do
      expect(@app_controller.validate_twitter_response('valid')).to eq('Successfully posted!')
    end
  end
  
  describe "get_tweets" do
      it "gets tweets successfully" do
        returnBody = "[:body => 'test']"
        allow(@app_controller.twitter_client).to receive(:home_timeline).and_return(returnBody)
        expect(@app_controller.twitter_client).to receive(:home_timeline)
        response = @app_controller.get_tweets()
        expect(response).to eq returnBody
      end
  end
  
  describe "process_text" do
    it "correclty identifies an empty post" do
      expect(@app_controller.process_text('')).to eq('You cannot make an empty post')
      expect(@app_controller.process_text(' ')).to eq('You cannot make an empty post')
    end
    
    it "posts successfully when text is not empty" do 
      returnStatus = 'Successful'
      allow(@app_controller.twitter_client).to receive(:update).and_return(returnStatus)
      expect(@app_controller.twitter_client).to receive(:update)
      expect(@app_controller.process_text('test post')).to eq('Successfully posted!')
    end
  end
  
  describe "process_image" do
    it "successfully posts with one image" do
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      allow(image).to receive(:original_filename).and_return('test_image.png')
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@app_controller.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      expect(@app_controller.process_image('', image)).to eq('Successfully posted!')
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
      allow(@app_controller.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      expect(@app_controller.process_images('', @images)).to eq('Successfully posted!')
    end
    
    it "fails to post more than 4 images" do
      5.times do 
        @images << @image
      end
      expect(@app_controller.process_images('', @images)).to eq('Do not upload more than 4 images at once')
    end
  end
   
end
   
   