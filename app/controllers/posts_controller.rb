class PostsController < ApplicationController
  def index
    @user = current_user
    if @user == nil
      redirect_to login_index_path
    else
      @client = current_client
    end
  end
end
