require 'csv'

desc "Import ASA groups from csv file"
task :import_asa => [:environment] do

  file = "db/asa_exec_emails.csv"

  CSV.foreach(file, :headers => false) do |row|
    AsaDb.create(:name => row[0], :email => row[1])
  end
end

task :import_events => [:environment] do
  # Gets events from clubs/interest groups from start_date to end_date. 
  client = Savon.client("http://events.mit.edu/MITEventsFull.wsdl")
  client.config.log = false
  response = client.request :mns, :get_category_events do
    soap.namespaces["xmlns:mns"] = "http://events.mit.edu/MIT/Events/EventManager"
    soap.body = {
  	  :category_id => 7,
  	  :start_date => "2012/11/01",
  	  :end_date => "2013/07/01"
    }
  end
  items = response.body[:get_category_events_response][:array][:item]
  items.each do |item|
  	# holidays don't have locations or description
  	if !item[:location] || !item[:description]
 	  next
 	end
  	event = Event.new
  	if Event.last
  	  event.id = Event.last.id + 1
  	else
  	  event.id = 1
  	end

  	event.title = item[:title]
  	event.location = item[:location]
  	event.description = item[:description]

    event.description += "\n\nSponsored by:\n"

    if item[:sponsors][:item][0]
      item[:sponsors][:item].each do |sponsor|
        event.description += sponsor[:name] + "\n"
      end
    else
      event.description += item[:sponsors][:item][:name] + "\n"	
    end
    event.description += "\nContact:\n" +
						item[:infoname].to_s + 
						"\n" + 
						item[:infomail].to_s
    timeblock = TimeBlock.new
    timeblock.starttime = item[:start][:year].to_s + "-" +
    					  item[:start][:month].to_s + "-" +
    					  item[:start][:day].to_s + " " +
    					  item[:start][:hour].to_s + ":" +
    					  item[:start][:minute].to_s + ":00"

    timeblock.endtime = item[:end][:year].to_s + "-" +
    					  item[:end][:month].to_s + "-" + 
    					  item[:end][:day].to_s + " " +
    					  item[:end][:hour].to_s + ":" +
    					  item[:end][:minute].to_s + ":00"
   	event.time_block = timeblock
   	event.save
  end
end

task :import => [:import_asa, :import_events]