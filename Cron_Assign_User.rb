require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

woTABLEID = "bfkavuvrv"
userTABLEID = "bfs8ea7bp"
userName = "reg.rms@regencylighting.com"
passWord = "R3g.Rm5pa55"

the_record_ids = Hash.new
queries = Hash[:uDispatch => "{\'192\'.XEX.\'1\'}AND{\'12\'.XEX.\'1\'}AND{\'62\'.TV.\'\'}",:uCloseOut => "{\'192\'.XEX.\'1\'}AND{\'12\'.EX.\'1\'}AND{\'63\'.TV.\'\'}",:uBilling => "{\'192\'.XEX.\'1\'}AND{\'12\'.EX.\'1\'}AND{\'16\'.XEX.\'1\'}AND{\'64\'.TV.\'\'}"]
the_next_user = Hash[:uDispatch => "udispatch",:uCloseOut => "ucloseout",:uBilling => "ubilling"]
the_user_ids =Hash.new
qbc = QuickBase::Client.new(userName,passWord)
qbc.printRequestsAndResponses = false

queries.each {|key, value|
	puts key
	puts value
	the_record_ids[key] = []
	the_user_ids[key] = []
	theRecordxml = "<xml>" + qbc.doQuery( woTABLEID, value, nil, nil, "3", nil, nil, nil ).join + "</xml>"
	puts theRecordxml
	doc = Document.new(theRecordxml)
	doc.elements.each("xml/record/record_id_") do |ele|
		the_record_ids[key] << ele.text
	end
}
the_record_ids.each_key {|key|
	puts "the_record_ids[#{key}] records are\n" # comment out this line later
	if the_record_ids[key].length > 0
		the_record_ids[key].each_index {|record|
			theUserxml = "<xml>" + qbc.doQuery( userTABLEID, nil, "10", nil, "34.51.66", nil, nil, nil ).join + "</xml>"
			puts theUserxml
			
			docx = Document.new(theUserxml)
			docx.elements.each("xml/record/#{the_next_user[key]}") do |ele|
			puts the_next_user[key]
			the_user_ids[key] << ele.text
			end
			
			puts "#{the_record_ids[key][record]} goes to #{the_next_user[key]} which is #{the_user_ids[key][record]}" # comment out this line later
			qbc.printRequestsAndResponses = false
			qbc.addFieldValuePair(the_next_user[key],nil,nil,the_user_ids[key][record])
			qbc.editRecord( woTABLEID, the_record_ids[key][record],qbc.fvlist,nil,nil,nil,nil)
		}
	end
}