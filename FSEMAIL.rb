def fwd2qb(username,password,file,tableDBID)
require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

	location_id = ""
	customer_PO = ""
	date_time_due = ""
	work_description = ""
	not_to_exceed = ""
	related_ship_to = ""
	related_customer = ""
	closed_ship_to = ""
	est_price = ""
	est_cost = ""
	request = []
File.readlines(file).each do |line|
  line.each_byte { |c|
    # only print the ascii characters we want to allow
    request << c.chr if c==9 || c==10 || c==13 || (c > 31 && c < 127)
  }
end

f = request.join.split(' ')

	customer_PO = f[3]
	location_id = f[5]
	date_time_due = f[f.index("Committed:")+1] + " " + f[f.index("Committed:")+2] + " " + f[f.index("Committed:")+3]
	work_description = f[(f.index("Request")+2)..(f.index("Provider:")-1)].join(' ')
	
	# puts customer_PO
	# puts location_id
	# puts date_time_due
	# puts work_description
		qbc = QuickBase::Client.new(username,password)
		qbc.printRequestsAndResponses = false
		theQuery = "{\'74\'.EX.\'" + location_id + "\'}"
		theRelatedLocationxml = qbc.doQuery( "bfkavuvqs", theQuery, nil, nil, "3.12.81.122.123", nil, nil, nil ).join
		# puts theRelatedLocationxml
		
		doc = Document.new(theRelatedLocationxml)
		doc.elements.each("record/record_id_") do |ele|
			related_ship_to << ele.text
		end
		doc.elements.each("record/related_customer") do |ele|
			related_customer << ele.text
		end
		
		doc.elements.each("record/closed_ship_to") do |ele|
			closed_ship_to << ele.text
		end
		
		doc.elements.each("record/avg_price_order") do |ele|
			est_price << ele.text unless ele.text == nil
		end

		doc.elements.each("record/avg_cost_order") do |ele|
			est_cost << ele.text unless ele.text == nil
		end
		
		if closed_ship_to != "1" && related_ship_to != ""
			# puts related_ship_to
			qbcx = QuickBase::Client.new(username,password)
			qbcx.printRequestsAndResponses = false
			# puts "Work Type " + "Product Only"
			# puts "Channel " + "Third Party"
			# puts "Not to Exceed " + not_to_exceed
			# puts "Sales_Order Labor Estimated Cost " + est_cost
			# puts "Sales_Order Labor Estimated Price " + est_price
			# puts "Work Description " + work_description
			# puts "Related Ship-To " + related_ship_to
			# puts "Related Customer " + related_customer
			# puts "Date/Time Due " + date_time_due
			# puts "PO# " + customer_PO
			qbcx.addFieldValuePair("Work Type",nil,nil,"On-Call")
			qbcx.addFieldValuePair("Channel",nil,nil,"Third Party")
			qbcx.addFieldValuePair("Not to Exceed",nil,nil,not_to_exceed)
			qbcx.addFieldValuePair("Sales_Order Labor Estimated Cost",nil,nil,est_cost) unless est_cost.to_i == 0
			qbcx.addFieldValuePair("Sales_Order Labor Estimated Price",nil,nil,est_price) unless est_price.to_i == 0
			qbcx.addFieldValuePair("Work Description",nil,nil,work_description)
			qbcx.addFieldValuePair("Related Ship-To",nil,nil,related_ship_to)
			qbcx.addFieldValuePair("Related Customer",nil,nil,related_customer)
			qbcx.addFieldValuePair("Date/Time Due",nil,nil,date_time_due)
			qbcx.addFieldValuePair("PO#",nil,nil,customer_PO)
			qbcx.addRecord(tableDBID,qbcx.fvlist)
		end
end
	
if ARGV[3]
  fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   