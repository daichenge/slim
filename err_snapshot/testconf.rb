require './package/readconf.rb'
hostname = `hostname`
dbconf = CollectLogs.new(hostname,"db")
["load", "process", "port", "applog"].each do |item|
  dbconf.collect_logs(item)
end
