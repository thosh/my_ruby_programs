require 'C:\Ruby\lib\ruby\gems\1.9.1\gems\quickbase_client-1.0.4\lib\QuickBaseClient.rb'
tableDBID = "bfkavuvrv"
username = "reg.rms@regencylighting.com"
password = "R3g.Rm5pa55"
t = Time.now
f = "\\\\Regfileshare01\\rms\\Conduit2.0_WOs_Export\\Work_Orders"+ t.strftime("%Y%m") + ".csv"
qbc = QuickBase::Client.new(username,password)
qbc.printRequestsAndResponses = false
qbc.makeSVFile( f, ",", tableDBID, nil, "257")
