require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
tableDBID = "bfkavuvrv"
username = "reg.rms@regencylighting.com"
password = "PASSWORD"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
theRecordxml = "<xml>" + qbc.doQuery( tableDBID, nil, "120", nil, nil, nil, nil, nil ).join + "</xml>"
# puts theRecordxml
doc = Document.new(theRecordxml)
related_ship_to = []
work_description = []
date_time_due = []
related_contractor = []
not_to_exceed = []
nte_contractor = []
related_customer = []
est_price = []
est_cost = []

doc.elements.each("xml/record/related_ship_to") do |ele|
related_ship_to << ele.text
end

doc.elements.each("xml/record/related_customer") do |ele|
related_customer << ele.text
end

doc.elements.each("xml/record/work_description") do |ele|
work_description << CGI::unescapeHTML(ele.text).gsub!("<BR/>","\n")
end

doc.elements.each("xml/record/ship_to___frml_next_sched_date_time_due") do |ele|
date_time_due << ele.text
end

doc.elements.each("xml/record/related_contractor") do |ele|
related_contractor << ele.text
end

doc.elements.each("xml/record/not_to_exceed") do |ele|
not_to_exceed << ele.text
end

doc.elements.each("xml/record/nte_contractor") do |ele|
nte_contractor << ele.text
end

doc.elements.each("xml/record/sales_order_labor_estimated_cost") do |ele|
est_cost << ele.text
end

doc.elements.each("xml/record/sales_order_labor_estimated_price") do |ele|
est_price << ele.text
end

related_ship_to.each_index {|i| 
qbcx = QuickBase::Client.new(username,password)
qbcx.printRequestsAndResponses = false
qbcx.addFieldValuePair("Work Type",nil,nil,"Scheduled")
qbcx.addFieldValuePair("Channel",nil,nil,"Auto")
qbcx.addFieldValuePair("Not to Exceed",nil,nil,not_to_exceed[i]) unless not_to_exceed[i].to_i == 0
qbcx.addFieldValuePair("NTE Contractor",nil,nil,nte_contractor[i]) unless nte_contractor[i].to_i == 0
qbcx.addFieldValuePair("Sales_Order Labor Estimated Cost",nil,nil,est_cost[i]) unless est_cost[i].to_i == 0
qbcx.addFieldValuePair("Sales_Order Labor Estimated Price",nil,nil,est_price[i]) unless est_price[i].to_i == 0
qbcx.addFieldValuePair("Work Description",nil,nil,work_description[i]) unless work_description[i].nil?
qbcx.addFieldValuePair("Related Ship-To",nil,nil,related_ship_to[i])
qbcx.addFieldValuePair("Date/Time Due",nil,nil,date_time_due[i])
qbcx.addFieldValuePair("Related Contractor",nil,nil,related_contractor[i])
qbcx.addFieldValuePair("Related Customer",nil,nil,related_customer[i])
qbcx.addRecord(tableDBID,qbcx.fvlist)
# COMMENT BELOW
# puts "not_to_exceed:" unless not_to_exceed[i].to_i == 0
# puts not_to_exceed[i] unless not_to_exceed[i].to_i == 0
# puts "nte_contractor:" unless nte_contractor[i].to_i == 0
# puts nte_contractor[i] unless nte_contractor[i].to_i == 0
# puts "work_description:"
# puts work_description[i]
# puts "related_ship_to:"
# puts related_ship_to[i]
# puts "date_time_due:"
# puts date_time_due[i]
# puts "related_contractor:"
# puts related_contractor[i]
# puts "related_customer:"
# puts related_customer[i]
# sleep 5
}
