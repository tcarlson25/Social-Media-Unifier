class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def twitter
        callback('twitter')
    end
    
    def facebook
        callback('facebook')
    end
    
    def mastodon
      callback('mastodon') 
    end
    
    def google_oauth2
      callback('google_oauth2') 
    end
    
    def callback(provider)
        if provider.eql?('google_oauth2')
            @user = User.from_omniauth(request.env["omniauth.auth"])
            if @user.persisted?
                sign_in_and_redirect @user, event: :authentication
                set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
            else
                session["devise.#{provider}_data"] = request.env["omniauth.auth"]
                redirect_to new_user_registration_path
            end
        else
            @identity = Identity.find_from_auth(request.env["omniauth.auth"])
            @user = @identity.user || current_user
            if @user.nil?
                if User.find_by(email: @identity.email).nil?
                    @user = User.create(email: @identity.email || "")
                    @identity.update_attribute(:user_id, @user.id)
                else
                    @user = User.find_by(email: @identity.email)
                    @identity.update_attribute(:user_id, @user.id)
                end
            end
           
            if @user.email.blank? && @identity.email
                @user.update_attribute(:email, @identity.email) 
            end
            if @user.persisted?
                @identity.update_attribute(:user_id, @user.id)
                if provider.eql?('twitter')
                    twitter_client = @user.twitter_client
                    @user.twitter.update(:profile_img => twitter_client.user.profile_image_url(size = :original))
                elsif provider.eql?('facebook')
                    facebook_client = @user.facebook_client
                    @user.facebook.update(:profile_img => facebook_client.get_picture(user['id'], {:type => 'large'}))
                elsif provider.eql?('mastodon')
                    mastodon_client = @user.mastodon_client
                    @user.mastodon.update(:profile_img => mastodon_client.verify_credentials.avatar)
                end
                
                sign_in_and_redirect @user, event: :authentication
                set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
            else
                session["devise.#{provider}_data"] = request.env["omniauth.auth"]
                redirect_to new_user_registration_path
            end
        end
        
        
    end
    
    def failure
        redirect_to root_path
    end
end