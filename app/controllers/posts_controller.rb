class PostsController < ApplicationController
  def index
    @user = current_user
    client = User.client(@user)
    puts tweets = client.home_timeline.full_text
  end
end
