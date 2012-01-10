require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		wonum = ""
		updateInfo = ""
		a = ""
		lastLine = ""
		puts IO.readlines(file)
		a = IO.readlines(file)
		lastLine = a.length
		a.each_index {|x|
			if a[x].include? "notify@quickbase.com"
			lastLine = x.to_i
			end
		}
		puts a
		for lineNum in 0...lastLine
			if lineNum == 0
				wonum = a[lineNum].chomp
				else
				updateInfo << a[lineNum]
			end
		end
	  theQuery = "({\'6\'.EX.\'" + wonum + "\'}OR{\'3\'.EX.\'" + wonum + "\'})"
		if wonum.length > 0 and updateInfo.length > 0
			# puts "hey"
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = true
			theRecordxml = qbc.doQuery( tableDBID, theQuery, nil, nil, "3", nil, nil, nil ).join
			theRecordID_start = theRecordxml.index("<record_id_>") + 12
			theRecordID_end = theRecordxml.index("</record_id_>") 
			theRecordID = theRecordxml.slice(theRecordID_start,theRecordID_end - theRecordID_start)
			qbc.addFieldValuePair("Notes_Logistics",nil,nil,updateInfo)
			qbc.editRecord(tableDBID, theRecordID, qbc.fvlist)
		end
	end
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end   