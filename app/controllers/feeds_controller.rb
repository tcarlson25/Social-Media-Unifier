class FeedsController < ApplicationController
  
  attr_accessor :client, :feed, :twitter_posts, :user, :providers
  
  def index
    @user = current_user
    if @user == nil
      flash[:notice] = set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      @feed = @user.feed
      @twitter_posts = get_tweets_from_db
    end
  end
  
  def messages
    @user = current_user
    if @user == nil
      flash[:notice] = set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end  
  end
  
  def archives
    @user = current_user
    if @user == nil
      flash[:notice] = set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end  
  end
  
  def notifications
    @user = current_user
    if @user == nil
      flash[:notice] = set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end
  end
  
  def post
    @user = current_user
    if @user == nil
      flash[:notice] = set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      @providers = ['Twitter', 'Facebook']
      if params[:providers]
        checked_providers = params[:providers].keys
        if checked_providers.include?('Twitter')
          unless params[:images].nil?
            if params[:images].size() == 1
              response = process_image(params[:post_content], params[:images][0])
              flash[:notice] = response
            else
              response = process_images(params[:post_content], params[:images])
              flash[:notice] = response
            end
          else
            response = process_text(params[:post_content])
            flash[:notice] = response
          end
        end
        
        if checked_providers.include?('Facebook')
          
        end
      end
    end
  end
  
end
