
require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		wonum = ""
		datex= ""
		updateInfo = ""
		subjArray =""
		subjString=""
		lastLine = ""
		a = ""
		a = IO.readlines(file)
		lastLine = a.length
		a.each_index {|x|
			if a[x].include? "notify@quickbase.com"
				lastLine = x.to_i
			end
		}
		for lineNum in 0...lastLine
			if lineNum == 0
				subjString = a[lineNum].chomp
				elsif lineNum == 1
				updateInfo = a[lineNum].dup
				else
				updateInfo << a[lineNum].dup
			end
		end
		subjArray = subjString.split(' ')
		wonum = subjArray[1]
		datex = subjArray[2]
		if wonum.length > 0 
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = false
			qbc.getSchema(tableDBID)
			if qbc.requestSucceeded
				if subjArray[2]
					qbc.addFieldValuePair("Date Work Completed",nil,nil,datex)
				end
				qbc.addFieldValuePair("Status",nil,nil,"Work Completed (Waiting on Paperwork)")
				qbc.addFieldValuePair("LMS Notes",nil,nil,updateInfo)
				qbc.editRecord(tableDBID,wonum,qbc.fvlist)
			end
		end
	end
end

if ARGV[3]
	fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
	
end   

