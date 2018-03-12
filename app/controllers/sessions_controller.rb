class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    @feed = Feed.find_or_create_from_user(@user)
    session[:user_id] = @user.id
    redirect_to root_path
  end
  
  def destroy
    if current_user
      session.delete(:user_id)
      flash[:notice] = "Successfully logged out"
    end
    redirect_to login_index_path
  end
 
  protected
 
  def auth_hash
    request.env['omniauth.auth']
  end
  
end