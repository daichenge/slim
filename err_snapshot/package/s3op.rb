require 'aws-sdk'
class S3Basic
  attr_accessor :s3client, :buckname
  def initialize(s3client, buckname)
    @s3client = s3client
    @buckname = buckname
  end
end

class S3List < S3Basic
  def list_s3()
    s3client.list_objects(bucket: buckname).each do |response|
      puts response.contents.map(&:key)
    end
  end
end

class S3Del < S3List
  attr_accessor :s3client, :buckname, :keyname
  def initialize(s3client, buckname, keyname)
    @keyname = keyname
    super(s3client, buckname)
  end
  def del_s3()
    s3client.delete_object(bucket:buckname, key: keyname)
  end
end

class S3PutGet < S3Del
  attr_accessor :s3client, :buckname, :keyname, :fname, :path
  def initialize(s3client, buckname, keyname, fname=keyname, path=File.dirname(__FILE__))
    @fname = fname
    @path = path
    super(s3client, buckname, keyname)
  end
  def get_s3()
      localfile = path + "/" + fname
      s3client.get_object({ bucket: buckname, key: keyname }, target: localfile)
  end  
  def put_s3()
    localfile = path + "/" + fname
    File.open(localfile, 'rb') do |file|
      s3client.put_object(bucket: buckname, key: keyname, body: file)
    end
  end
end
