require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		IO.foreach(file){|line|
			wo = ""
			filepath = ""
			lineArray = ""
			lineArray = line.dup
			lineArray = lineArray.split(',')
			filepath = lineArray[0]
			wo = lineArray[1]
			if filepath.length > 0 and wo.length > 0
				qbc = QuickBase::Client.new(username,password)
				qbc.printRequestsAndResponses = false
				qbc.getSchema(tableDBID)
				if qbc.requestSucceeded
					qbc.addFieldValuePair("Link to Purchase Order",nil,nil,filepath)
					qbc.editRecord(tableDBID,wo,qbc.fvlist)
				end
			end
		}
	end
end


if ARGV[3]
	fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
end
