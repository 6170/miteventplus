class TagsController < ApplicationController

  # creates a new tag object, and responds with that tag
  # as a json object
  # requires that a valid name is passed in with params
  def create
    @new_tag = current_user.tags.create(:name => params[:name])
    respond_to do |format|
      format.json{ render :json => @new_tag}
    end 
  end

  # destroys a tag with a given id, and then renders text
  # requires that a valid id of a tag is passed in with params.
  def destroy
    current_user.tags.find(params[:id]).delete
    render :text => "Success!"
  end
end
