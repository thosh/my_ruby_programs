require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"

tableName = ['E4-Delete Lamps','E4-Delete Action Items','E4-Delete Contractor Invoices','E4-Delete Fixtures','Lightspeed-Delete Quotes','E4-Delete Proposed Applications', 'E4-Delete Proposed Ballast','E4-Delete Proposed Fixtures','E4-Delete Proposed Lamps','E4-Delete Existing Ballast','E4-Delete Existing Lamps','E4-Delete Existing Applications','E4-Delete ECMs','E4-Delete Retrofit Activities','E4-Delete Locations','E4-Stale Existing Applications','E4-Stale Existing Lamps','E4-Stale Proposed Applications','E4-Stale Proposed Ballast','E4-Stale Proposed Fixtures','E4-Stale ECMs','E4-Stale Existing Ballast','E4-Stale Proposed Lamps','E4-Stale Proposed Accessories','C2-Delete Attachments']
tableID = ['bevw65uhc','bevw65ugy','be5wghvvp','bevw65uhe','bfa7tmu4f','bevw65ug5','bevw65ug7','bevw65ug8','bevw65uhu','bevw65uhv','bevw65ug6','bevw65ug4','bevw65ug3','bevw65ug2','bevw65ugz','bevw65ug4','bevw65ug6','bevw65ug5','bevw65ug7','bevw65ug8','bevw65ug3','bevw65uhv','bevw65uhu','bevw65ug9','bfkavuvvq']
queryID = ['6','37','13','7','10','49','22','23','28','22','28','32','138','290','181','40','36','56','28','28','152','28','34','17','18']

qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false

if tableName.length == tableID.length && tableID.length == queryID.length
	tableName.each_index {|tbl|
		# puts tableName[tbl]
		theDeleteRecords = []
		theRecordxml = "<xml>" + qbc.doQuery( tableID[tbl], nil, queryID[tbl], nil, '3', nil, nil, nil ).join + "</xml>"
		# puts theRecordxml
		doc = Document.new(theRecordxml)
		
		
		doc.elements.each("xml/record/record_id_") do |ele|
		theDeleteRecords << ele.text
		end
		
		if theDeleteRecords.length > 0
			theDeleteRecords.each{|rcd|
				qbc.deleteRecord(tableID[tbl],rcd)
				puts "I am deleting record #{rcd} in the #{tableName[tbl]} table"
				sleep 1
			}
		end
	}
end