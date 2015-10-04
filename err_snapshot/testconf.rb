require './readconf.rb'
hostname = `hostname`
dbconf = CollectLogs.new(hostname,"db")
dbconf.collect_logs("process")
