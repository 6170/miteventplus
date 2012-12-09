class HomeController < ApplicationController
  before_filter :check_logged_in

  # renders the home page, which is static so we don't need
  # any logic in this controller action.
  def index
  end

  # checks to see if a user is currently logged in
  # if not, they are redirected to the sign in page.
  def check_logged_in
    if current_user != nil
      redirect_to user_path(current_user)
    end
  end
end
