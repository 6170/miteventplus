class UsersController < ApplicationController
  before_filter :authenticate_user!

  # controller action for the dashboard
  # passes in the current user and a new event object to create a new event
  # requires that a user is logged in
  def show
    @user = current_user
    @event = @user.events.new
  end
end