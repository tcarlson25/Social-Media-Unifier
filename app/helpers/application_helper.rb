module ApplicationHelper
  
  def set_sign_in_required
    flash[:notice] = "Log in with Twitter to use this application"
  end

end
