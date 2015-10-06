require './package/readconf.rb'
require './package/s3op.rb'
require 'find'
hostname = `hostname`
=begin
dbconf = CollectLogs.new(hostname,"db")
["load", "process", "port", "applog"].each do |item|
  dbconf.collect_logs(item)
end
=end
s3client = Aws::S3::Client.new(region: 'ap-southeast-1')
["load.log", "process.log", "port.log", "applog.log"].each do |item|
  logbak = S3PutGet.new(s3client, 'slim-chef/err_snapshot/' + hostname, item, item, "logs")
  logbak.put_s3()
end
#path = File.dirname(__FILE__)
#puts path
