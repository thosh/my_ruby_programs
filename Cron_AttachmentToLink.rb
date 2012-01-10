require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

tableDBID = "bfkavuvvq"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"

my_rids = []
my_filenames = []
my_prefixes =[]


qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
theRecordxml = "<xml>" + qbc.doQuery( tableDBID, nil, "33", nil, nil, nil, nil, nil ).join + "</xml>"
# puts theRecordxml
doc = Document.new(theRecordxml)

doc.elements.each("xml/record/record_id_") do |ele|
	my_rids << ele.text
end

doc.elements.each("xml/record/file_attachment") do |ele|
	my_filenames << ele.text.gsub('#',"_")
end

doc.elements.each("xml/record/prefix") do |ele|
	my_prefixes << ele.text
end

my_rids.each_index {|i|
# puts "\\\\Regfileshare01\\rms\\Conduit2.0\\Attachments\\" + my_prefixes[i] + my_filenames[i]
# puts "file:\\\\R:\\rms\\Conduit2.0\\Attachments\\#{my_prefixes[i]}#{my_filenames[i]}"
qbc.downLoadFile( tableDBID , my_rids[i], 17)
File.open("\\\\Regfileshare01\\rms\\Conduit2.0\\Attachments\\" + my_prefixes[i] + my_filenames[i], "wb") {|f|f.write(qbc.fileContents)}
qbc.updateFile( tableDBID, my_rids[i], "delete", "File Attachment", { "File Link" => "file:\\\\R:\\rms\\Conduit2.0\\Attachments\\#{my_prefixes[i]}#{my_filenames[i]}" })
}