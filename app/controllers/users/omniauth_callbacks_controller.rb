class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def twitter
        callback('twitter')
    end
    
    def facebook
        callback('facebook')
    end
    
    def callback(provider)
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
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
        else
            session["devise.#{provider}_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_path
        end
    end
    
    def failure
        redirect_to root_path
    end
end