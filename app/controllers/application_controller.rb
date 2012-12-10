class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :check_logged_in

  def check_logged_in
    if !current_user
      flash[:alert] = 'Please sign in to continue'

      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.js { render 'sign_in' }
      end
    end
  end

  def after_sign_in_path_for(user)
	  user_path(user)
  end

end
