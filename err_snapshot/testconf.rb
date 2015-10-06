require './package/readconf.rb'
require './package/s3op.rb'
require 'find'
hostname = `hostname`
time = Time.now.strftime("%Y-%m-%d")
dbconf = CollectLogs.new(hostname,"db")
["load", "process", "port", "applog"].each do |item|
  dbconf.collect_logs(item)
end
s3client = Aws::S3::Client.new(region: 'ap-southeast-1')
["load.log", "process.log", "port.log", "applog.log"].each do |item|
  buckname = 'slim-chef/err_snapshot/' + time + "/" + hostname
  logbak = S3PutGet.new(s3client, buckname, item, item, "logs")
  logbak.put_s3()
end
