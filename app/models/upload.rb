class Upload < ActiveRecord::Base
  attr_accessible :upload
  has_attached_file :upload, :styles => { :thumb => ["120x120#", :png]}
  belongs_to :event
  before_post_process :is_image?

  include Rails.application.routes.url_helpers

  def to_jq_upload
    output = {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "delete_url" => upload_path(self), 
      "delete_type" => "DELETE" 
    }
    if self.is_image?
      output.merge("thumbnail_url" => upload.url(:thumb))
    end
  end

  def to_redactor_img
    {
      "thumb" => upload.url(:thumb),
      "image" => upload.url(:original),
      "title" => read_attribute(:upload_file_name)
    }
  end

  def is_image?
    ["image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"].include?(self.upload_content_type) 
  end

end
