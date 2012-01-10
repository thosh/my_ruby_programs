require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'

def attachment_to_link(username,password,file,tableDBID)
		my_rid = ""
	  my_filename = ""
		my_filelink = ""
		my_related_wo = ""
		my_related_wo_type = ""
		lineArray = ""
  if FileTest.exist?(file)
    IO.foreach(file){|line|
			lineArray = line.split(',')
			my_rid = lineArray[0]
			my_filename = lineArray[1]
			my_filelink = lineArray[2]
			my_related_wo = lineArray[3]
			my_related_wo_type = lineArray[4]
			qbc = QuickBase::Client.new(username,password)
			qbc.printRequestsAndResponses = true
			qbc.downLoadFile( tableDBID , my_rid, 17)
			File.open(my_filename, "wb") {|f|f.write(qbc.fileContents)}
			qbc.updateFile( tableDBID, my_rid, "delete", "File Attachment", { "File Link" => "#{my_filelink}" })
			if my_related_wo.nil? == false and my_related_wo_type == "Scheduled"
				qbcX = QuickBase::Client.new(username,password)
				qbcX.printRequestsAndResponses = false
				qbcX.getSchema("bfkavuvrv")
				qbcX.addFieldValuePair("chk_Sent To AM",nil,nil,"true")
				qbcX.editRecord("bfkavuvrv",my_related_wo,qbcX.fvlist)
			end
		}
  end
end

if ARGV[3]
	attachment_to_link(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
end