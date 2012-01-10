require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		filePath = ""
		assignedTo = ""
		assignedBy = ""
		theSubject = ""
		updateInfo = ""
		theToUser = ""
		theByUser = ""
		lineNum=1
		IO.foreach(file){|line|
			if lineNum == 1
				assignedBy = line.chomp
			  elsif lineNum == 2      
				assignedTo = line.chomp
				elsif lineNum == 3
					theSubject = line
				elsif lineNum == 4
					filePath = line 
				else
					updateInfo << line.dup.gsub(/[^[:print:]]/, '') + "\n"
			end
			lineNum += 1
		}
		if assignedTo.length > 0
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = true
			theToUser = "-" + qbc.getUserInfo(assignedTo).attributes.get_attribute("id").value.split(".")[0].to_s
			theByUser = "-" + qbc.getUserInfo(assignedBy).attributes.get_attribute("id").value.split(".")[0].to_s
			qbc.addFieldValuePair("Assigned By",nil,nil,theByUser)
			qbc.addFieldValuePair("Assigned To",nil,nil,theToUser)
			qbc.addFieldValuePair("Subject",nil,nil,theSubject)
			qbc.addFieldValuePair("Additional Information",nil,nil,updateInfo)
			qbc.addFieldValuePair("Link to File",nil,nil,filePath)
			qbc.addRecord(tableDBID,qbc.fvlist)
		end
	end
end

if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end 