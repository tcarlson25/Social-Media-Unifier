require 'rails_helper'
require './spec/support/helpers'

RSpec.describe FeedsHelper, type: :helper do
  
  before do
    @test_user = create(:user)
    @test_feed = @test_user.feed
    @test_twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = @test_user.twitter.token
      config.access_token_secret = @test_user.twitter.secret
    end
    @test_facebook_client = Koala::Facebook::API.new(@test_user.facebook.token)
    @test_mastodon_client = Mastodon::REST::Client.new(base_url: 'https://mastodon.social', bearer_token: @test_user.mastodon.token)
    helper.twitter_client = @test_twitter_client
    helper.facebook_client = @test_facebook_client
    helper.mastodon_client = @test_mastodon_client
    helper.user = @test_user
  end
  
  describe "#validate_responses" do
    it "correctly identifies invalid twitter response, valid facebook response, and valid mastodon response" do
      expect(helper.validate_responses(nil, 'valid', 'valid')).to eq({:errors => ['Could not post to Twitter.']})
    end
    
    it "correctly identifies valid twitter response and valid facebook response and valid mastodon response" do
      expect(helper.validate_responses('valid', 'valid', 'valid')).to eq({:errors => ['Posted Successfully!']})
    end
    
    it "correctly identifies a valid twitter response and invalid facebook response and valid mastodon response" do
      expect(helper.validate_responses('valid', nil, 'valid')).to eq({:errors => ['Could not post to Facebook.']})
    end
    
    it "correctly identifies a invalid twitter response and invalid facebook response and invalid mastodon response" do
      expect(helper.validate_responses(nil, nil, nil)).to eq({:errors => ['Could not post to Twitter.', 'Could not post to Facebook.', 'Could not post to Mastodon.']})
    end
  end
  
  describe "#process_text" do
    it "correctly identifies an empty post" do
      expect(helper.process_text('')).to eq({:errors => ['You cannot make an empty post']})
      expect(helper.process_text(' ')).to eq({:errors => ['You cannot make an empty post']})
    end
    
    it "posts successfully when text is not empty" do 
      returnStatus = 'Successful'
      allow_any_instance_of(FeedsHelper).to receive(:update_image_postcount).and_return(true)
      expect(helper.twitter_client).to receive(:update)
      expect(helper.facebook_client).to receive(:put_wall_post)
      expect(helper.mastodon_client).to receive(:create_status)
      expect(helper.process_text('test post')).to eq({:errors => ['Posted Successfully!']})
    end
  end
  
  describe "#process_image" do
    it "successfully posts with one image" do
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      allow(image).to receive(:original_filename).and_return('test_image.png')
      allow(FileUtils).to receive(:rm).and_return(true)
      allow(helper.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      allow(helper.facebook_client).to receive(:put_picture).and_return(returnStatus)
      allow(helper.mastodon_client).to receive_message_chain(:upload_media, :id).and_return(1)
      allow(helper.mastodon_client).to receive(:create_status).and_return(returnStatus)
      allow_any_instance_of(FeedsHelper).to receive(:update_image_postcount).and_return(true)
      expect(helper.process_image('', image)).to eq({:errors => ['Posted Successfully!']})
    end
  end
  
  describe "#process_images" do 
    before do
      @image = mock_archive_upload("app/assets/images/test_image.png", "image/png")
      @images = []
      @fb_photo = {'id' => 1}
      allow(@image).to receive(:original_filename).and_return('test_image')
      allow(FileUtils).to receive(:rm).and_return(true)
    end
    
    it "successfully posts with no more than 4 images" do
      2.times do
        @images << @image
      end
      expect(FileUtils).to receive(:rm)
      
      returnStatus = 'Successful'
      allow(helper.twitter_client).to receive(:update_with_media).and_return(returnStatus)
      allow(helper.facebook_client).to receive(:put_picture).and_return(@fb_photo)
      allow(helper.facebook_client).to receive(:put_connections).and_return(returnStatus)
      allow(helper.mastodon_client).to receive_message_chain(:upload_media, :id).and_return(1)
      allow(helper.mastodon_client).to receive(:create_status).and_return(returnStatus)
      expect(helper.process_images('', @images)).to eq({:errors => ['Posted Successfully!']})
    end
    
    it "fails to post more than 4 images" do
      5.times do 
        @images << @image
      end
      expect(helper.process_images('', @images)).to eq({:errors => ['Do not upload more than 4 images at once']})
    end
  end
  
  describe '#update_postcount' do
    it "increases all provider's post count after successful posts" do
      before_count = helper.user.twitter.post_count
      helper.update_postcount('success', 'success', 'success')
      expect(helper.user.twitter.post_count).to eql(before_count + 1)
      expect(helper.user.facebook.post_count).to eql(before_count + 1)
      expect(helper.user.mastodon.post_count).to eql(before_count + 1)
    end
    
    it "doesn't update provider's post count after failed posts - nil" do
      before_count = helper.user.twitter.post_count
      helper.update_postcount(nil, nil, nil)
      expect(helper.user.twitter.post_count).to eql(before_count)
      expect(helper.user.facebook.post_count).to eql(before_count)
      expect(helper.user.mastodon.post_count).to eql(before_count)
    end
    
    it "doesn't update provider's post count after failed posts - empty" do
      before_count = helper.user.twitter.post_count
      helper.update_postcount('', '', '')
      expect(helper.user.twitter.post_count).to eql(before_count)
      expect(helper.user.facebook.post_count).to eql(before_count)
      expect(helper.user.mastodon.post_count).to eql(before_count)
    end
  end
  
  describe '#process_uris' do
    it 'surrounds https links with link tags' do
      text = 'https://test.link.com'
      result = process_uris(text)
      expect(result).to eql('<a href="https://test.link.com">https://test.link.com</a>')
    end
    
    it 'surrounds http links with link tags' do
      text = 'http://test.link.com'
      result = process_uris(text)
      expect(result).to eql('<a href="http://test.link.com">http://test.link.com</a>')
    end
  end
  
end
