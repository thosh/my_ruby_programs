require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

def fwd2qb(username,password,file,tableDBID)
		wonum = ""
		updateInfo = ""
		a = ""
		lastLine = ""
		theRecordID = []
		a = IO.readlines(file)
		lastLine = a.length
		for lineNum in 0...lastLine
			if lineNum == 0
				wonum = a[lineNum].chomp.split[2][3..-1]
			end
			if a[lineNum].include? "Proposal Amount"
				updateInfo << a[lineNum].chomp + "\n"
			elsif a[lineNum].include? "Status Updated"
			  updateInfo << a[lineNum].chomp + "\n"
			elsif a[lineNum].include? "Updated By"
			  updateInfo << a[lineNum].chomp + "\n"
			end
		end
		# puts wonum
	  theQuery = "{\'107\'.CT.\'" + wonum + "\'}"
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
		# puts updateInfo
		qbc.addFieldValuePair("Notes_Customer",nil,nil,updateInfo)
		qbc.addFieldValuePair("On Hold For",nil,nil,"Active")
		qbc.editRecord(tableDBID, theRecordID[i], qbc.fvlist)
		}
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   