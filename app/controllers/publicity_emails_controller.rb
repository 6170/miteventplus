class PublicityEmailsController < ApplicationController
  before_filter :load_parent
  
  # AJAX query queries for this to set the mail form fields to a previous email's contents
  def show
    @publicity_email = @event.publicity_emails.find(params[:id])
    respond_to do |format|
      format.json{ render :json => @publicity_email}
    end
  end

  # called when publicity email is sent. Stores a copy of the email's contents under the event.
  def create
    @publicity_email = @event.publicity_emails.create(params[:publicity_email])
    Email.new(:title => @publicity_email.subject, :email => @event.user.email, :message => @publicity_email.content.gsub('<img src="/system', '<img src="eventplus.herokuapp.com/system')).deliver
    
    @event.checklist_items.find_by_tag("publicity").set_checked_true
    redirect_to :root, :notice => "Publicity email sent to your exec mailing list."
  end

  private
  def load_parent
    @event = current_user.events.find(params[:event_id])
  end
end
