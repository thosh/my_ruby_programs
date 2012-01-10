require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		wonum = ""
		updateInfo = ""
		a = []
		lastLine = ""
		a = IO.readlines(file)
		lastLine = a.length
		theRecordID = []
		a.each_index {|x|
			if a[x].include? "PREVIOUS NOTE"
			lastLine = x.to_i
			end
		}
		for lineNum in 0...lastLine
			if lineNum == 0
				wonum = a[lineNum].split[a[lineNum].split.index('Tr.') + 1][2..-1]
				else
				updateInfo << a[lineNum]
			end
		end
	  theQuery = "{\'155\'.EX.\'" + wonum + "\'}"
		if wonum.length > 0 and updateInfo.length > 0
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = false
			theRecordxml = "<xml>" + qbc.doQuery( tableDBID, theQuery, nil, nil, "3", nil, nil, nil ).join + "</xml>"
			# puts theRecordxml
			doc = Document.new(theRecordxml)
			doc.elements.each("xml/record/record_id_") do |ele|
			 theRecordID << ele.text
			end
			theRecordID.each_index {|i|
			qbc.addFieldValuePair("Notes_Customer",nil,nil,updateInfo)
			qbc.editRecord(tableDBID, theRecordID[i], qbc.fvlist)
			}
		end
	end
end

if ARGV[3]
  fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   