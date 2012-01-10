require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'rexml/document'
include REXML

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
	  qbc = QuickBase::Client.new(username,password)
		qbc.printRequestsAndResponses = false
	  wo=[]
		filepath=[]
		i=0
		IO.foreach(file){|line|
			filepath[i] = line.split(',')[0]
			wo[i] = line.split(',')[1].chomp
			i += 1
		}
		wo.each_index {|x|
		  theRecord=[]
			theQuery = "{\'6\'.CT.\'#{wo[x]}\'}"
			# puts theQuery
			theRecordxml = "<xml>" + qbc.doQuery( "bfkavuvrv", theQuery, nil, nil, "3", nil, nil, nil ).join + "</xml>"
			# puts theRecordxml
			doc = Document.new(theRecordxml)
			doc.elements.each("xml/record/record_id_") do |ele|
				theRecord << ele.text
			end
			if theRecord[0]
				# puts "the record is" + theRecord[0]
				# puts wo[x]
				# puts filepath[x]
				qbc.addFieldValuePair("File Link",nil,nil,filepath[x])
				qbc.addFieldValuePair("Related Work Order",nil,nil,theRecord[0])
				qbc.addFieldValuePair("Type",nil,nil,"Work Summary")
				qbc.addRecord(tableDBID,qbc.fvlist)
			end
		}
	end
end


if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
 end