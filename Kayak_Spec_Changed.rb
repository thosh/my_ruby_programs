require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

today = Time.now
yesterday = Time.now - (60 * 60 * 24) 
today_file = "C:\\Ruby\\E4_Retrofits\\"+ today.strftime("%Y%m%d") + ".txt"
yesterday_file = "C:\\Ruby\\E4_Retrofits\\"+ yesterday.strftime("%Y%m%d") + ".txt"
record_ids = []
emails = []
existing_application_descriptions = []
proposed_retrofit_actions = []
doc = []
yreport = []
treport = []
rid = ""
email = ""
theToUser = ""
updateInfo = []


qbc = QuickBase::Client.new("reg.rms@regencylighting.com","R3g.Rm5pa55")
qbc.printRequestsAndResponses = false

theRecordxml = "<xml>" + qbc.doQuery( "bevw65ug2", nil, "329", nil, nil, nil, nil, nil ).join + "</xml>"
rpt = Document.new(theRecordxml)

rpt.elements.each("xml/record/record_id_") do |ele|
record_ids << ele.text
end

rpt.elements.each("xml/record/location___ownertoemail") do |ele|
emails << ele.text
end

rpt.elements.each("xml/record/existing_application_description") do |ele|
existing_application_descriptions << CGI::unescapeHTML(ele.text)
end

rpt.elements.each("xml/record/proposed_retrofit_action") do |ele|
proposed_retrofit_actions << CGI::unescapeHTML(ele.text)
end

record_ids.each_index {|i|
doc << "#{record_ids[i]},#{emails[i]},#{existing_application_descriptions[i]},#{proposed_retrofit_actions[i]}\r"
}

File.open(today_file, 'w') {|f| f.write(doc.join) }

if FileTest.exist?(yesterday_file) && FileTest.exist?(today_file)
	IO.foreach(yesterday_file){|line|
		yreport << line
	}
	IO.foreach(today_file){|line|
		treport << line
	}
	if treport == yreport
		puts "equal--no action"
		exit
	end
	diff = ((treport | yreport) - (treport & yreport)).sort
	diff.each_index {|d|
		if d.even?
			email = diff[d].split(',')[1]
			updateInfo << "Link to changed record:\n"
			updateInfo << "https://www.quickbase.com/db/bevw65ug2?a=dr&rid=" + diff[d].split(',')[0] + "\n\n"
			theToUser = "-" + qbc.getUserInfo(email).attributes.get_attribute("id").value.split(".")[0].to_s
			updateInfo << "Existing:\n" + diff[d].split(',')[2] + "\nTo Proposed:\n" + diff[d].split(',')[3] + "\nhas been changed to\n\n"
		else
			updateInfo << "Existing:\n" + diff[d].split(',')[2] + "\nTo Proposed:\n" + diff[d].split(',')[3]
			qbc.addFieldValuePair("Assigned To",nil,nil,theToUser)
			qbc.addFieldValuePair("Subject",nil,nil,"Retrofit Activity Changed on Location Ready for Spec Review")
			qbc.addFieldValuePair("Additional Information",nil,nil,updateInfo.join)
			qbc.addRecord("bcwtz9iw6",qbc.fvlist)
			puts email
			puts updateInfo
			updateInfo.clear
			qbc.clearFieldValuePairList 
		end
	}
end