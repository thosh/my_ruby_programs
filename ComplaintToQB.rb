require 'date'
require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		filePath = ""
		sentByEmail = ""
		sentBy = ""
		updateInfo = ""
		lineNum=1
		IO.foreach(file){|line|
			if lineNum == 1        
				sentByEmail = line
				elsif lineNum == 2
					sentBy = line            
				else
					updateInfo << line.dup.gsub(/[^[:print:]]/, '') + "\n"
			end
			lineNum += 1
		}
		if sentByEmail.length > 0
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = false
			qbc.addFieldValuePair("Contact Email",nil,nil,sentByEmail)
			qbc.addFieldValuePair("Contact",nil,nil,sentBy)
			qbc.addFieldValuePair("Details",nil,nil,updateInfo)
			qbc.addRecord(tableDBID,qbc.fvlist)
		end
	end
end

if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end 