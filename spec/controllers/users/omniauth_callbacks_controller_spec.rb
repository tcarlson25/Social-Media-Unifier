require 'rails_helper'
require './spec/support/helpers.rb'

describe Users::OmniauthCallbacksController, type: :controller do
    
    before do
        #allow(Identity).to receive(:find_from_auth).and_return()
    end
    
    describe "callback" do
       it "creates an identity from the auth hash" do
           
       end
    end
end