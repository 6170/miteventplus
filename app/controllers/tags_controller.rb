class TagsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def create
    @new_tag = current_user.tags.create(:name => params[:name])
    respond_to do |format|
      format.json{ render :json => @new_tag}
    end 
  end

  def destroy
    Tag.find(params[:id]).delete
    render :text => "Success!"
  end

end
