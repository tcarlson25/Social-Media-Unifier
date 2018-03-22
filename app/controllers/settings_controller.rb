class SettingsController < ApplicationController
  
  attr_accessor :client, :user
  
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
    end 
  end
  
  def metrics
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
    end
  end
  
  def custom_friends
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
    end
  end
  
  def accounts
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
    end
  end
  
end
