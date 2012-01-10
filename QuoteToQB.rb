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
				elsif lineNum == 3
					filePath = line
				else
					updateInfo << line.dup.gsub(/[^[:print:]]/, '') + "\n"
			end
			lineNum += 1
		}
		if sentByEmail.length > 0
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = false
			qbc.getSchema(tableDBID)
			t = Date.today
			case t.wday
				when 0 then dd= t+ 5
				when 1 then dd= t+ 4
				when 2..6 then dd= t+6
			end
			if qbc.requestSucceeded
				qbc.addFieldValuePair("Date Due",nil,nil,dd.strftime("%m-%d-%Y"))
				qbc.addFieldValuePair("Contact Email",nil,nil,sentByEmail)
				qbc.addFieldValuePair("Contact",nil,nil,sentBy)
				qbc.addFieldValuePair("Details",nil,nil,updateInfo)
				qbc.addFieldValuePair("Link to File Attachment",nil,nil,filePath)
				qbc.addRecord(tableDBID,qbc.fvlist)
			end
		end
	end
end

if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end 