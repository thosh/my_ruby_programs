require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

def fwd2qb(username,password,file,tableDBID)
		thePO = ""
		a = ""
		theArray = []
		theRecordID = []
		a = IO.readlines(file)
		theArray = a[0].split
		theArray.each {|str| thePO = str if str =~/\d{8}/}
		puts thePO
	  theQuery = "{\'155\'.CT.\'" + thePO + "\'}"
		qbc = QuickBase::Client.new(username,password)
		qbc.printRequestsAndResponses = false
		theRecordxml = "<xml>" + qbc.doQuery( tableDBID, theQuery, nil, nil, "3", nil, nil, nil ).join + "</xml>"
		# puts theRecordxml
		
		doc = Document.new(theRecordxml)
		doc.elements.each("xml/record/record_id_") do |ele|
		 theRecordID << ele.text
		end
		
		theRecordID.each_index {|i|
		# puts theRecordID[i]
		# puts a[0]
		qbc.addFieldValuePair("Notes_Dispatch",nil,nil,a[0])
		qbc.addFieldValuePair("chk_Cancel WO",nil,nil,"1")
		qbc.editRecord(tableDBID, theRecordID[i], qbc.fvlist)
		}
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   