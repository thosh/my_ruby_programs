require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		wonum = ""
		updateInfo = ""
		a = ""
		lastLine = ""
		theQuery = ""
		theRecordxml = ""
		theRecordID = ""
		theRecordID_start = ""
		theRecordID_end = ""
		a = IO.readlines(file)
		lastLine = a.length
		a.each_index {|x|
			if a[x].include? "Click HYPERLINK"
				lastLine = x.to_i
			end
		}
		wonum = a[2].split[2]
		for lineNum in 0...lastLine
			updateInfo << a[lineNum].dup.gsub(/[^[:print:]]/, '') + "\n"
		end
		theQuery = "{\'6\'.EX.\'" + wonum + "\'}"
		qbc = QuickBase::Client.new(username,password)
		qbc.addFieldValuePair("Audit Trail",nil,nil,updateInfo)
		qbc.printRequestsAndResponses = true
		theRecordxml = qbc.doQuery( tableDBID, theQuery, nil, nil, "3", nil, nil, nil ).join
		if not theRecordxml.index("<record_id_>").nil?
			theRecordID_start = theRecordxml.index("<record_id_>") + 12
			theRecordID_end = theRecordxml.index("</record_id_>") 
			theRecordID = theRecordxml.slice(theRecordID_start,theRecordID_end - theRecordID_start)
			qbc.editRecord(tableDBID, theRecordID, qbc.fvlist)
			else
			qbc.addFieldValuePair("Related Work Order",nil,nil,wonum)
			qbc.addRecord(tableDBID, qbc.fvlist)
		end
	end
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   