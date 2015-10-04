require 'iniparse'
class Conf
  attr_accessor :name, :type, :path
  def initialize(name, type, path=File.dirname(__FILE__))
    @name = name
    @type = type
    @path = path
  end
end

class ReadConf < Conf
  def get_conf(func)
    conf_hash = Hash.new
    iniparse = IniParse.open("#{path}/conf/#{func}.conf")
    iniparse[type.upcase].each do |item|
      conf_hash[item.key] = item.value
    end
    if func == "log" 
      iniparse["system"].each do |item|
        conf_hash[item.key] = item.value
      end
    end
    return conf_hash
  end
end

class CollectLogs < ReadConf
  def collect_logs(func)
    File.delete("logs/#{func}.log") if File::exists?( "logs/#{func}.log" )
    get_conf("#{func}").each do | key ,value |
      if value != 0
        sysFile = File.new("logs/#{func}.log","a+")
        cmd_list = ["lsof -c #{key}","ps aux|grep #{key}|grep -v grep"] if func == "process"
        cmd_list = ["netstat -an | grep #{value}"] if func == "port"
        cmd_list = ["tail -100 #{value}"] if func == "applog"
        cmd_list.each do |cmd|
          sysFile.syswrite(`#{cmd}`)
        end
        sysFile.syswrite("-"*80)
        sysFile.syswrite("\n")
        sysFile.close()
      end
    end
  end
end

