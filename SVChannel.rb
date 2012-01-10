require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

def service_channel_WO_create(username,password,file,loc_tableDBID)
  time_now = Time.new
	if time_now.wday == 5
		time_now += (60 * 60 * 48)
	elsif time_now.wday == 6
		time_now += (60 * 60 * 24)
	end
	wo_type = ""
	the_customer = []
  wo_tableDBID = "bfkavuvrv"
	requested_by = ""
  location_id = ""
	customer_PO = ""
	work_description = ""
	do_not_exceed = ""
	priority_of_request = ""
	related_ship_to = ""
	related_contractor = ""
	date_time_due = ""
	time_due = ""
	related_customer =""
	est_price = ""
	est_cost = ""
	
	if FileTest.exist?(file)
		IO.foreach(file){|line|
			if line.include? "Store ID"
				location_id = line.split[-1]
			elsif line.include? "Call created by"
				requested_by = line.split.drop(3).join(" ") + "\n"
			elsif line.include? "Subscriber:"
				the_customer = line.split.drop(1).join(" ")
			elsif line.include? "WO #:"
				customer_PO = line.split[-1]
			elsif line.include? "Description1:"
				work_description = line.split.drop(1).join(" ").gsub(/[^[:print:]]/," ")
			elsif line.include? "NTE:"
				do_not_exceed = line.split[-1]
			elsif line.include? "Priority:"
				priority_of_request = line.split[1]
			end
		}
	end
	# COMMENT OUT THE FOLLOWING
	# puts location_id
	# puts customer_PO
	# puts work_description
	# puts do_not_exceed
	# puts priority_of_request
	# puts the_customer
	if priority_of_request.include? 'mergenc'
	  time_due = time_now + (60 * 60 * 24)
		wo_type = "Emergency"
	else
	  time_due = time_now + (60 * 60 * 72)
		wo_type = "On-Call"
	end
	
	if time_due.wday == 0
		time_due += (60 * 60 * 24)
	elsif time_due.wday == 6
		time_due += (60 * 60 * 48)
	end
	  
	qbc = QuickBase::Client.new(username,password)
	qbc.printRequestsAndResponses = false
	theQuery = "{\'13\'.CT.\'#{the_customer}\'}AND{\'57\'.EX.\'#{location_id}\'}"
	theRecordxml = "<xml>" + qbc.doQuery( loc_tableDBID, theQuery, nil, nil, "3.28.33.12.122.123", nil, nil, nil ).join + "</xml>"
	# puts theRecordxml
	doc = Document.new(theRecordxml)
	related_ship_to = XPath.first( doc, "//record_id_" ).text
	related_contractor = XPath.first( doc, "//preferred_contractor" ).text
	related_customer = XPath.first( doc, "//related_customer" ).text
	est_price = XPath.first( doc, "//avg_price_order" ).text
	est_cost = XPath.first( doc, "//avg_cost_order" ).text
	
	# puts do_not_exceed
	# puts work_description
	# puts related_ship_to 
	# puts related_contractor
	# puts time_due.strftime("%m/%d/%Y %I:%M%p")
	# puts the_customer
	qbcx = QuickBase::Client.new(username,password)
	qbcx.printRequestsAndResponses = false
	qbcx.addFieldValuePair("Work Type",nil,nil,wo_type)
	qbcx.addFieldValuePair("Channel",nil,nil,"Third Party")
	qbcx.addFieldValuePair("Not to Exceed",nil,nil,do_not_exceed) unless do_not_exceed.to_i == 0
	qbcx.addFieldValuePair("Sales_Order Labor Estimated Cost",nil,nil,est_cost) unless est_cost.to_i == 0
	qbcx.addFieldValuePair("Sales_Order Labor Estimated Price",nil,nil,est_price) unless est_price.to_i == 0
	qbcx.addFieldValuePair("Work Description",nil,nil,requested_by + "\n" + work_description)
	qbcx.addFieldValuePair("Related Ship-To",nil,nil,related_ship_to)
	qbcx.addFieldValuePair("Related Customer",nil,nil,related_customer)
	qbcx.addFieldValuePair("PO#",nil,nil,customer_PO)
	qbcx.addFieldValuePair("Date/Time Due",nil,nil,time_due.strftime("%m/%d/%Y %I:%M%p"))
	qbcx.addFieldValuePair("Related Contractor",nil,nil,related_contractor) unless related_contractor.nil?
	qbcx.addRecord(wo_tableDBID,qbcx.fvlist)
end

if ARGV[3]
  service_channel_WO_create(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end