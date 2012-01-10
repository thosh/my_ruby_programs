require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
woTableID = "bfkavuvrv"
driveLogTableID = "bgexmn4t7"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
theDLRecordIDs = []
theDLDateTrucks = []
theWORecordIDs = []
theWODateTrucks = []
theWORelatedDLs = []

#Check Drive Log for Today's Related Drive Logs
theDriveLogxml = "<xml>" + qbc.doQuery(driveLogTableID, nil, "6", nil, nil, nil, nil, nil ).join + "</xml>"
docDR = Document.new(theDriveLogxml)

theWOxml = "<xml>" + qbc.doQuery(woTableID, nil, "243", nil, nil, nil, nil, nil ).join + "</xml>"
doc = Document.new(theWOxml)

if theDriveLogxml.length > 10 && theWOxml.length > 10

	doc.elements.each("xml/record/record_id_") do |ele|
		theWORecordIDs << ele.text
	end

	doc.elements.each("xml/record/datetruck") do |ele|
		theWODateTrucks << ele.text
	end

	docDR.elements.each("xml/record/record_id_") do |ele|
		theDLRecordIDs << ele.text
	end
	docDR.elements.each("xml/record/datekeytruck") do |ele|
		theDLDateTrucks << ele.text
	end


	theDLDateTrucks.each_index {|dldt|
		# puts "For DL DateTruck #{theDLDateTrucks[dldt]}" # comment this
		theWODateTrucks.each_index {|wodt|
			# puts "For WO DateTruck #{theWODateTrucks[wodt]}" # comment this
			# sleep 1 # comment this
			if theWODateTrucks[wodt] == theDLDateTrucks[dldt]
				theWORelatedDLs[wodt] = theDLRecordIDs[dldt]
			end
		}
	}
		
	theWORecordIDs.each_index {|woid|
	qbc.addFieldValuePair("Related Drive Log",nil,nil,theWORelatedDLs[woid])
	qbc.editRecord(woTableID, theWORecordIDs[woid], qbc.fvlist)
	# puts "changing record # #{theWORecordIDs[woid]} to related drive log #{theWORelatedDLs[woid]}" # comment this
	}
end