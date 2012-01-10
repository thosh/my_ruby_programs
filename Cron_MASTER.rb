loop{
t = Time.now
puts t.strftime("%H:%M%p")

if t.strftime("%H") == "01"
	puts "*****P21_WO_Import******"
	load 'Cron_P21_WO_Import.rb'
end

if t.strftime("%H") == "03"
	if t.strftime("%d") == "01"
	 load'Cron_Hoons_Monthly_WO_export.rb'
	end
	puts "*****Drive Log******"
	load 'Cron_New_Drive_Log.rb'
	puts "*****Connect_Drive_Log******"
	load 'Cron_Connect_Drive_Log.rb'
	puts "*****Uncheck Insurance Notification******"
	load 'Cron_Uncheck_Insurance_Notification.rb'
	puts "*****Delete_Bot******"
	load 'Cron_Delete_Bot.rb'
	puts "*****New Sched WO******"
	load 'Cron_New_Sched_WO.rb'
end

if t.strftime("%H") == "23"
load 'Cron_P21_WO_Import_SO_Back.rb'
end

puts "*****New WO Old PPWK*****"
load 'Cron_New_Sched_WO_get_OLD_PPWK.rb'
puts "******Cron_Close_Product_Only*****"
load 'Cron_Close_Product_Only.rb'
puts "******Cron_AttachmentToLink*****"
load 'Cron_AttachmentToLink.rb'

sleep 60*59
}
