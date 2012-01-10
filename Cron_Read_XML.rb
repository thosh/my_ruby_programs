require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

xmlTableDBID = "bgpz98f37"
woTableDBID = "bfkavuvrv"
shiptoTableDBID = "bfkavuvqs"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"
msgs = []
rids = []
docs = []
theWOIDs = []
theShipToIDs = []
theCustToIDs = []
theProblems = []
theNotes = []
theContractors = []
thePrices = []
theCosts = []
x = 0 

qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false

doc = Document.new("<xml>" + qbc.doQuery( xmlTableDBID, nil, "5", nil, nil, nil, nil, nil ).join + "</xml>")

#GETS EACH OF THE UNREAD XML MESSAGES
doc.elements.each("xml/record/xmlmsg") do |ele|
	msgs << ele.text
end

#GETS EACH OF THE PROBLEMS
doc.elements.each("xml/record/problem") do |ele|
	theProblems << ele.text
end

#GETS EACH OF THE NOTES
doc.elements.each("xml/record/note") do |ele|
	theNotes << ele.text
end

# GETS EACH OF THE RECORD IDs
doc.elements.each("xml/record/record_id_") do |ele|
	rids << ele.text
end

# MARKS EACH OF THE UNREAD XML MESSAGES AS READ
rids.each do |r| 
	qbc.addFieldValuePair("Read",nil,nil,"1")
	qbc.editRecord(xmlTableDBID, r, qbc.fvlist)
end

m = "<xml>" + msgs.join + "</xml>"

msgdoc = Document.new(m)

msgdoc.elements.each("xml/DATA2SC/CALL") do |ele|

	msg = {}
	ele.attributes.each_attribute do |attr| 
		msg[attr.expanded_name] = attr.value
	end
	
	
	# LOOKS FOR EXISTING WO FIRST BY PO# = SVC TR_NUM
	theWOQuery = "{\'155\'.EX.\'" + msg["TR_NUM"] + "\'}"
	d = Document.new("<xml>" + qbc.doQuery( woTableDBID, theWOQuery, nil, nil, "3", nil, nil, nil ).join + "</xml>")
	d.elements.each("xml/record/record_id_") do |ele|
		theWOIDs << ele.text
	end
	qbc.printRequestsAndResponses = false
	if theWOIDs.size>0 # IF THERE IS A WO WITH THIS PO#, THEN UPDATE
		theWOIDs.each_index do |i|
			qbc.addFieldValuePair("Notes_Customer",nil,nil,msg["CALLER"] + "\n" ) #+ theNotes[x])
			qbc.editRecord(woTableDBID, theWOIDs[i], qbc.fvlist)
			qbc.clearFieldValuePairList
		end
		theWOIDs = []
	else #CREATE A NEW WO
			theShipToQuery = "{\'133\'.EX.\'" + msg["SUB"] + msg["LOC"] + "\'}"
			d2 = Document.new("<xml>" + qbc.doQuery( shiptoTableDBID, theShipToQuery, nil, nil, "3.12", nil, nil, nil ).join + "</xml>")
			d2.elements.each("xml/record/record_id_") do |ele|
				theShipToIDs << ele.text
			end
			d2.elements.each("xml/record/related_customer") do |ele|
				theCustToIDs << ele.text
			end
			d2.elements.each("xml/record/preferred_contractor") do |ele|
				theContractors << ele.text
			end
			d2.elements.each("xml/record/avg_cost_order") do |ele|
				theCosts << ele.text
			end
			d2.elements.each("xml/record/avg_price_order") do |ele|
				thePrices << ele.text
			end
			if theShipToIDs[0]
				qbc.addFieldValuePair("Work Type",nil,nil,"On-Call")
				qbc.addFieldValuePair("Channel",nil,nil,"Third Party")
				qbc.addFieldValuePair("Not to Exceed",nil,nil,msg["NTE"])
				qbc.addFieldValuePair("Sales_Order Labor Estimated Cost",nil,nil,theCosts[0]) unless theCosts[0].to_i == 0
				qbc.addFieldValuePair("Sales_Order Labor Estimated Price",nil,nil,thePrices[0]) unless thePrices[0].to_i == 0
				qbc.addFieldValuePair("Work Description",nil,nil,msg["CALLER"] + "\n" + theProblems[x])
				qbc.addFieldValuePair("Related Ship-To",nil,nil,theShipToIDs[0])
				qbc.addFieldValuePair("Related Customer",nil,nil,theCustToIDs[0])
				qbc.addFieldValuePair("PO#",nil,nil,msg["TR_NUM"])
				qbc.addFieldValuePair("Date/Time Due",nil,nil,msg["SCHED_DATETIME"])
				qbc.addFieldValuePair("Related Contractor",nil,nil,theContractors[0]) unless theContractors[0].nil?
				qbc.addRecord(woTableDBID,qbc.fvlist)
				qbc.clearFieldValuePairList
			end
			theShipToIDs = []
			theCustToIDs = []
	end
	 x += 1
	msg.clear
end