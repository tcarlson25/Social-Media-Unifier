class SettingsController < ApplicationController
  
  def index
    @user = current_user
    if @user == nil
        redirect_to login_index_path
    else
        @client = current_client
    end 
  end
  
  def metrics
    @user = current_user
    if @user == nil
        redirect_to login_index_path
    else
        @client = current_client
    end
  end
  
  def custom_friends
    @user = current_user
    if @user == nil
        redirect_to login_index_path
    else
        @client = current_client
    end
  end
  
  def accounts
    @user = current_user
    if @user == nil
        redirect_to login_index_path
    else
        @client = current_client
    end
  end
  
end
