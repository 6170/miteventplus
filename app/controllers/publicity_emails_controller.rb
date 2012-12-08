class PublicityEmailsController < ApplicationController
  before_filter :load_parent
  
  def new
  end

  def create
    @publicity_email = @event.publicity_emails.new(params[:publicity_email])
    Email.new(:title => @publicity_email.subject, :email => @event.user.email, :message => @publicity_email.content.gsub('<img src="/system', '<img src="eventplus.herokuapp.com/system')).deliver
    redirect_to :root
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  private

  def load_parent
    @event = current_user.events.find(params[:event_id])
  end
end
