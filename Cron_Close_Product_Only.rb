require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
tableDBID = "bfkavuvrv"
username = "reg.rms@regencylighting.com"
password = "PASSWORD"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
theRecordxml = "<xml>" + qbc.doQuery( tableDBID, nil, "237", nil, nil, nil, nil, nil ).join + "</xml>"
# puts theRecordxml
doc = Document.new(theRecordxml)
theWOs = []

doc.elements.each("xml/record/record_id_") do |ele|
	theWOs << ele.text
end

qbcx = QuickBase::Client.new(username,password)
qbcx.printRequestsAndResponses = false
theWOs.each {|wo| 
qbcx.addFieldValuePair("chk_Customer Invoiced",nil,nil,"1")
qbcx.editRecord(tableDBID, wo, qbcx.fvlist)
# COMMENT BELOW
# puts "changing record # #{wo}"
}
