require 'rails_helper'

describe ApplicationController, type: :controller do
    before do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      @user = create(:user)
      # session[:user_id] = @user.id
      @client = Twitter::REST::Client.new do |config|
         config.consumer_key        = ENV['TWITTER_KEY']
         config.consumer_secret     = ENV['TWITTER_SECRET']
         config.access_token        = @user.token
         config.access_token_secret = @user.secret
      end
      @app_controller = ApplicationController.new()
   end
   
   #describe "Finding #current_user" do
    #   it "Should find the current used based on session" do
     #      allow(User).to receive(:find).and_return(@user)
      #     @app_controller = ApplicationController.new()
       #    response = @app_controller.current_user
        #   expect(response).to eq(@user)
       #end
   #end
   
  describe "making #current_client" do
    it "makes the current client" do
      allow(Twitter::REST::Client).to receive(:new).and_return(@client)
      response = @app_controller.current_client
      expect(response).to eq(@client)
      expect(response.consumer_key).to eq(ENV['TWITTER_KEY'])
      expect(response.consumer_secret).to eq(ENV['TWITTER_SECRET'])
      expect(response.access_token).to eq(@user.token)
      expect(response.access_token_secret).to eq(@user.secret)
    end
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
  
  describe "process_text" do
    it "correclty identifies an empty tweet" do
      expect(@app_controller.process_text('')).to eq('You cannot post an empty tweet')
      expect(@app_controller.process_text(' ')).to eq('You cannot post an empty tweet')
    end
    
    it "posts successfully when text is not empty" do 
      returnStatus = 'Successful'
      @app_controller.client = @client
      allow(@app_controller.client).to receive(:update).and_return(returnStatus)
      expect(@app_controller.client).to receive(:update)
      expect(@app_controller.process_text('test post')).to eq('Successfully posted!')
    end
  end
  
  describe "process_image" do
    it "successfully posts with one image" do
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      @app_controller.client = @client
      image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      allow(image).to receive(:original_filename).and_return('test_image.png')
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@app_controller.client).to receive(:update_with_media).and_return(returnStatus)
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
      @app_controller.client = @client
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(@app_controller.client).to receive(:update_with_media).and_return(returnStatus)
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
   
   