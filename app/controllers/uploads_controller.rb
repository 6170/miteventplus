  class UploadsController < ApplicationController
  before_filter :load_parent #for all below methods, require that user must own the event
  before_filter :check_logged_in #for all below methods, require that user must be logged in

  # gives list of all event uploads in json
  def index
    @uploads = @event.uploads

    respond_to do |format|
      format.html
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end
  end

  # gives event upload as json object
  def show
    @upload = @event.uploads.find(params[:id])

    respond_to do |format|
      format.json { render json: @upload }
    end
  end

  # creates new event upload and renders json representation of upload or error messages
  def create
    @upload = @event.uploads.new(params[:upload])

    respond_to do |format|
      if @upload.save
        format.html {
          render :json => [@upload.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: [@upload.to_jq_upload].to_json, status: :created, location: [@event, @upload] }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end


  # destroys upload, if it belongs to the event
  def destroy
    @upload = @event.uploads.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  # finds all images associated with event
  def images
    @images = @event.uploads.where(:upload_content_type => ["image/png", "image/gif", "image/jpe", "image/jpeg"])

    respond_to do |format|
      format.json { render json: @images.map{|image| image.to_redactor_img } }
    end

  end

  # upload image from within redactor (publicity email sending). Returns json of file information or error message
  def create_from_redactor
    @image = @event.uploads.new
    @image.upload = params[:file]    
    if @image.is_image?
      if @image.upload
        @image.save 
      end
      render :text => { :filelink => @image.upload.url }.to_json
    else
      render :text => {"error" => "Only image uploads allowed here"}.to_json
    end
  end

  private

  def load_parent
    @event = current_user.events.find(params[:event_id])
  end

end
