class PostsController < ApplicationController
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
    end
  end
  
  def messages
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end  
  end
  
end
