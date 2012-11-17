class HomeController < ApplicationController
  before_filter :check_logged_in

  def index
  end

  def check_logged_in
    if current_user != nil
      redirect_to user_path(current_user)
    end
  end
end
