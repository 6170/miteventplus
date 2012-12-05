class UploadsController < ApplicationController
  before_filter :load_parent, :except => :destroy
  before_filter :check_logged_in
  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = @event.uploads

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @upload = @event.uploads.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = @event.uploads.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = @event.uploads.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = @event.uploads.new(params[:upload])

    respond_to do |format|
      if @upload.save
        format.html {
          render :json => [@upload.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: [@upload.to_jq_upload].to_json, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @upload = @event.uploads.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  def images
    @images = @event.uploads.where(:upload_content_type => ["image/png", "image/gif", "image/jpe", "image/jpeg"])

    respond_to do |format|
      format.html # images.html.erb
      format.json { render json: @images.map{|image| image.to_redactor_img } }
    end

  end

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

  def check_logged_in
    if !current_user
      flash[:alert] = 'Please sign in to continue'

      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.js { render 'sign_in' }
      end
    end
  end

end
