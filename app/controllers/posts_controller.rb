class PostsController < ApplicationController
  def index
    @user = current_user
    @client = current_client
  end
end
