class UsersController < ApplicationController
  before_filter :authenticate_user!

  # controller action for the dashboard
  # passes in the current user and a new event object to create a new event
  # requires that a user is logged in
  def show
    @user = current_user
    @event = @user.events.new
  end
  
  # updates a given user with a new user object that is passed in
  # requires that a valid id for a user is passd in with params.
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  # destroys a certain user that is not the currently logged in user.
  # requires that a valid id for a user is passed in with params.
  def destroy
    user = User.find(params[:id])
    unless user === current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end