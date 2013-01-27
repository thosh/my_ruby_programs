require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

attachTableDBID = "bfkavuvvq"
woTableDBID = "bfkavuvrv"
username = "reg.rms@regencylighting.com"
password = "PASSWORD"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
qbc.getSchema(attachTableDBID)

theRecordxml = "<xml>" + qbc.doQuery( attachTableDBID, nil, "28", nil, nil, nil, nil, nil ).join + "</xml>"
# puts "theRecordxml\n"
# puts theRecordxml
doc = Document.new(theRecordxml)
theNewRecords = []
theOldLinks = []

doc.elements.each("xml/record/newwoid_oldppwk") do |ele|
theNewRecords << ele.text
end
doc.elements.each("xml/record/file_link") do |ele|
theOldLinks << ele.text
end

arrayRecordsToLinks = []
hashRecordsToLinks = {}
theGiantQuery = []

theNewRecords.each_index {|i|
arrayRecordsToLinks << [theNewRecords[i],theOldLinks[i]]
theGiantQuery << "{\'3\'.EX.\'#{theNewRecords[i]}\'}"
}
# puts "theGiantQuery\n"
# puts theGiantQuery.join('OR')

arrayRecordsToLinks.each {|k,v| hashRecordsToLinks[k]=v}
# puts "hashRecordsToLinks\n"
# puts hashRecordsToLinks

checkForAttachmentsXML = "<xml>" + qbc.doQuery( woTableDBID, "{'20'.EX.'0'}AND(" + theGiantQuery.join('OR') + ")", nil, nil, "3", nil, nil, nil ).join + "</xml>"
# puts "checkForAttachmentsXML\n"
# puts checkForAttachmentsXML

doc2 = Document.new(checkForAttachmentsXML)
theNewRecordsThatNeedAttachments = []


doc2.elements.each("xml/record/record_id_") do |ele|
theNewRecordsThatNeedAttachments << ele.text
end

# puts "theNewRecordsThatNeedAttachments\n"
# puts theNewRecordsThatNeedAttachments.length 

if theNewRecordsThatNeedAttachments.length >0
	theNewRecordsThatNeedAttachments.each_index {|i|
		puts theNewRecordsThatNeedAttachments[i] + " " + hashRecordsToLinks[theNewRecordsThatNeedAttachments[i]]
		qbc.addFieldValuePair("Related Work Order",nil,nil,theNewRecordsThatNeedAttachments[i])
		qbc.addFieldValuePair("File Link",nil,nil,hashRecordsToLinks[theNewRecordsThatNeedAttachments[i]])
		qbc.addFieldValuePair("Type",nil,nil,"Attachment")
		qbc.addFieldValuePair("Notes",nil,nil,"Last Scheduled WO WS")
		qbc.addRecord(attachTableDBID, qbc.fvlist)
}
end
