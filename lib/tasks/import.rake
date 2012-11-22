require 'csv'

desc "Import ASA groups from csv file"
task :import => [:environment] do

  file = "db/asa_exec_emails.csv"

  CSV.foreach(file, :headers => false) do |row|
    AsaDb.create(:name => row[0], :email => row[1])
  end
end