require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
tableDBID = 'bfkavuvrv'
username = 'reg.rms@regencylighting.com'
password = 'PASSWORD'
t = Time.now
file = "\\\\Regfileshare01\\rms\\Conduit2.0\\P21OrderImport\\WOSOimport" + t.strftime('%Y%m%d') + ".txt"
f = File.new(file, "r")
contents = f.read.gsub('-1','').gsub(/\n+/,"\n").split(/\n/)
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
contents.each {|record|
	r = record.split
	# puts "recordid=" + r[0]
	# puts "sales order # = " + r[1]
	qbc.addFieldValuePair("Sales_Order Labor",nil,nil,r[1])
	qbc.editRecord(tableDBID, r[0], qbc.fvlist)
}
