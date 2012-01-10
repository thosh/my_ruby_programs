def saveToFile(file,doc,date)
	save_to_file = "\\\\Regfileshare01\\CorporateShare\\P21Imports\\FTPOrder\\Active\\" + file + date + "C.txt"
	# save_to_file = "\\\\Regfileshare01\\rms\\_Conduit Attachments\\" + file + date + "C.txt"
	File.open(save_to_file, 'w') {|f| f.write(doc) }
end

require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
repDate = Time.now - (60 * 60 * 24) 
reqDate =  Time.now + (60 * 60 * 24 * 365)
# puts reqDate

theImportSets = []
theCustomerIDs = []
theCustomerPOs = []
theOrderTakers = []
theShipToIDs = []
theCarrierIDs = []
theLaborPrices = []
theLaborCosts = []
theSupplierIDs = []
theItemIDs = []
theOE3ClassIDs = []
theHeaderFile = []
theLineFile = []
theDispositions = []


woTableDBID = "bfkavuvrv"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false

theReportXML =  "<xml>" + qbc.doQuery( woTableDBID, nil, "254", nil, nil, nil, nil, nil ).join + "</xml>"
# puts theReportXML
rpt = Document.new(theReportXML)


if theReportXML != "<xml></xml>"
	rpt.elements.each("xml/record/record_id_") do |ele|
		theImportSets << ele.text
	end

	rpt.elements.each("xml/record/p21_customer_id") do |ele|
		theCustomerIDs << ele.text
	end

	rpt.elements.each("xml/record/contractor___p21_supplier_id") do |ele|
		ele.text ||= "1004702"
		theSupplierIDs << ele.text	
		if ele.text == "1004702" 
			theItemIDs << "RL RMS - JOB BREAKOUT"
			theDispositions << ""
		else
			theItemIDs << "RMS - JOB BREAKOUT"
			theDispositions << "D"
		end
	end

	rpt.elements.each("xml/record/po_") do |ele|
		if ele.text.nil?
			theCustomerPOs << ""
		else
			theCustomerPOs << ele.text
		end
	end

	rpt.elements.each("xml/record/ordertaker") do |ele|
		theOrderTakers << ele.text
	end

	rpt.elements.each("xml/record/p21_ship_to_id") do |ele|
		theShipToIDs << ele.text
	end

	rpt.elements.each("xml/record/sales_order_labor_estimated_price") do |ele|
		theLaborPrices << ele.text
	end

	rpt.elements.each("xml/record/sales_order_labor_estimated_cost") do |ele|
		theLaborCosts << ele.text
	end

	rpt.elements.each("xml/record/p21_oe_3_class_id") do |ele|
		theOE3ClassIDs << ele.text
	end

	theImportSets.each_index do |i|
		theHeaderFile << theImportSets[i] + "\t" + theCustomerIDs[i] + "\t\tRL\t300\t" + theCustomerPOs[i] +"\t\t\t" + theOrderTakers[i] + "\tImport\t\t\tN\tY\t" + theShipToIDs[i] + "\t\t\t\t\t\t\t\t\t\t\t\t\tWO#:" + theImportSets[i] + "-1\t\t\t\tOE1-13\t\t" + theOE3ClassIDs[i] + "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
		theLineFile << theImportSets[i] + "\t1\t" + theItemIDs[i] + "\t1\tEA\t" + theLaborPrices[i] + "\t\t\t\t\t" + theSupplierIDs[i] + "\t\t" + reqDate.strftime("%m/%d/%Y") + "\t" + reqDate.strftime("%m/%d/%Y") + "\t\t\t\t\t\t\t" + theLaborCosts[i] + "\t" + theDispositions[i] + "\t\tY\t\t\t\t\t\t\t\t\t\t"
	end

	saveToFile("FOH",theHeaderFile.join("\n"),repDate.strftime("%Y%m%d"))
	saveToFile("FOL",theLineFile.join("\n"),repDate.strftime("%Y%m%d"))
end