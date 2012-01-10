require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML
contractorTableID = "bbfijy4j7"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"

class MyQuickBaseClient < QuickBase::Client
	# API_EditRecord
	def myEditRecord( dbid, rid, fvlist, disprec = nil, fform = nil, ignoreError = nil, update_id = nil, msInUTC =nil, key = nil )
		@dbid, @rid, @fvlist, @disprec, @fform, @ignoreError, @update_id, @msInUTC, @key = dbid, rid, fvlist, disprec, fform, ignoreError, update_id, msInUTC, key
		setFieldValues( fvlist, false ) if fvlist.is_a?(Hash) 
		xmlRequestData = toXML( :rid, @rid ) if @rid
		xmlRequestData = toXML( :key, @key ) if @key
		@fvlist.each{ |fv| xmlRequestData << fv } #see addFieldValuePair, clearFieldValuePairList, @fvlist
		xmlRequestData << toXML( :disprec, @disprec ) if @disprec
		xmlRequestData << toXML( :fform, @fform ) if @fform
		xmlRequestData << toXML( :ignoreError, "1" ) if @ignoreError
		xmlRequestData << toXML( :update_id, @update_id ) if @update_id
		xmlRequestData << toXML( :msInUTC, "1" ) if @msInUTC
		sendRequest( :editRecord, xmlRequestData )
		@rid = getResponseValue( :rid )
		@update_id = getResponseValue( :update_id )
		return self if @chainAPIcalls
		return @rid, @update_id
	end
end


qbc = MyQuickBaseClient.new(username,password)
qbc.printRequestsAndResponses = false
qbc.getSchema(contractorTableID)
theRecordxml = "<xml>" + qbc.doQuery( contractorTableID, nil, "74", nil, nil, nil, nil, nil ).join + "</xml>"
# puts theRecordxml
doc = Document.new(theRecordxml)
contractors = []

doc.elements.each("xml/record/contractor") do |ele|
	contractors << ele.text
end

contractors.each {|contractor| 
qbc.addFieldValuePair(" 90 Day Notice Sent",nil,nil,"")
qbc.addFieldValuePair(" 60 Day Email Sent",nil,nil,"")
qbc.addFieldValuePair(" 30 Day Call Made",nil,nil,"")
qbc.myEditRecord(contractorTableID, nil, qbc.fvlist,nil, nil, nil, nil, nil, contractor)
# COMMENT BELOW
puts "changing record # #{contractor}"
}