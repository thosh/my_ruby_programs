require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		filePath = ""
		assignedTo = ""
		theSubject = ""
		updateInfo = ""
		theUser =""
		lineNum=1
		IO.foreach(file){|line|
			if lineNum == 2     
				assignedTo = line.chomp
				elsif lineNum == 1
					theSubject = line
				else
					updateInfo << line.dup.gsub(/[^[:print:]]/, '') + "\n"
			end
			lineNum += 1
		}
		if assignedTo.length > 0
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = true
			theUser = "-" + qbc.getUserInfo(assignedTo).attributes.get_attribute("id").value.split(".")[0].to_s
			qbc.addFieldValuePair("Assigned To",nil,nil,theUser)
			qbc.addFieldValuePair("Subject",nil,nil,theSubject)
			qbc.addFieldValuePair("Additional Information",nil,nil,updateInfo)
			qbc.addRecord(tableDBID,qbc.fvlist)
		end
	end
end

if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end 