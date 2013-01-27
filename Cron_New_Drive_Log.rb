require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
tableDBID = "bgexmn4t7"
username = "reg.rms@regencylighting.com"
password = "PASSWORD"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
truck_nos = ["904","905"]

truck_nos.each{|truck|
qbc.addFieldValuePair("Truck#",nil,nil,truck)
qbc.addFieldValuePair("DateKEYTRUCK",nil,nil,Time.now.strftime("%m-%d-%Y") + truck)
qbc.addRecord(tableDBID,qbc.fvlist)
}
