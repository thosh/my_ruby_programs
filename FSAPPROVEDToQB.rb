require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

def fwd2qb(username,password,file,tableDBID)
		wonum = ""
		a = ""
		lastLine = ""
		theRecordID = []
		a = IO.readlines(file)
		wonum = a[0].split[0].gsub!(/\(*|\)*/,"")
		# puts wonum
	  theQuery = "{\'155\'.EX.\'" + wonum + "\'}"
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
		# puts a
		qbc.addFieldValuePair("Notes_Dispatch",nil,nil,a)
		qbc.addFieldValuePair("On Hold For",nil,nil,"Active")
		qbc.editRecord(tableDBID, theRecordID[i], qbc.fvlist)
		}
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   