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
      "delete_url" => event_upload_path(self.event, self), 
      "delete_type" => "DELETE" 
    }
    if self.is_image?
      output = output.merge("thumbnail_url" => upload.url(:thumb))
    end
    output
  end

  def to_redactor_img
    {
      "thumb" => upload.url(:thumb),
      "image" => upload.url(:original),
      "title" => read_attribute(:upload_file_name)
    }
  end

  def is_image?
    !(self.upload_content_type =~ /^image.*/).nil?
  end

end
