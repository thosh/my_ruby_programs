require 'date'
require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
require 'cgi'
require 'rexml/document'
include REXML

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

def fwd2qb(username,password,file,tableDBID)
	if FileTest.exist?(file)
		contractor = ""
		updateInfo = ""
		a = ""
		a = IO.readlines(file)
		lastLine = a.length
		a.each_index {|x|
			if a[x].include? "Click on"
			lastLine = x.to_i
			end
		}
		for lineNum in 0...lastLine
			if lineNum == 0
				contractor = a[lineNum].chomp
			elsif lineNum == 1
				updateInfo << a[lineNum].split(' ')[0,2].join(' ')
			else
				updateInfo << a[lineNum]
			end
		end
		if contractor.length > 0
			qbc = MyQuickBaseClient.new(username,password)
			qbc.printRequestsAndResponses = true
			qbc.addFieldValuePair("ChangeLog",nil,nil,updateInfo)
			qbc.myEditRecord(tableDBID, nil, qbc.fvlist,nil, nil, nil, nil, nil, contractor)
		end
	end
end

if ARGV[3]
   fwd2qb(ARGV[0], ARGV[1], ARGV[2], ARGV[3]) 
end 