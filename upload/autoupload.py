'''
Created on Mar 21, 2015

@author: Slim Dai
'''

from fabric.api import *
from boto import ec2
from fabric.colors import *
import ConfigParser
import sys
'''
define a function to get all instance id
'''
def get_instance_list(my_reserve):
    my_inst_instances = {}
    for nums in range(0,len(my_reserve)):
        if len(my_reserve[nums].instances) > 1:
            for num in range(0,len(my_reserve[nums].instances)):
                my_inst_instances[my_reserve[nums].instances[num].__str__()] = my_reserve[nums].instances[num].__dict__
        else:
            my_inst_instances[my_reserve[nums].instances[0].__str__()] = my_reserve[nums].instances[0].__dict__
    return my_inst_instances

# define a connection to connect aws console
def get_conn_env(env):
    ec2_conn = ec2.connect_to_region("eu-west-1", profile_name = env)
    my_reserves = ec2_conn.get_all_reservations()
    return my_reserves

#output simple columns according to AWS console
def output_instance(my_dict):
        out_dict = {}
        for key in my_dict.keys():
                if 'Name' in my_dict[key]['tags'] and str(my_dict[key]['_state'])=='running(16)':
                        name = my_dict[key]['tags']['Name']
                        ip = my_dict[key]['ip_address']
                        if name in out_dict.keys():
                            out_dict[name].append(ip)
                        else:
                            out_dict[name] = []
                            out_dict[name].append(ip)
        return out_dict

config = ConfigParser.ConfigParser()
config.read('conf/autoupload.conf')
envname = raw_input("please specify an env name(demo|prod):").strip()
env_list = ["demo","prod"]
if envname == "" or envname not in env_list:
    print "you don't specify the correct environment name"
    sys.exit()
environment = config.get(envname,"env")
env.roledefs = output_instance(get_instance_list(get_conn_env(environment)))
env.user = config.get(envname,"username")
env.key_filename = config.get(envname,"keyfile")
@runs_once
def get_role():
    print yellow("You can specify the role name as below:")
    for name in env.roledefs.keys():
        print name
def upload_file(lfile,remotepath):
    put(lfile,remotepath)
def check_file(rpath):
    cmd = "ls -l " +  rpath
    run(cmd)
def go():
    localfile = raw_input("please input a local file needing to upload:").strip()
    rpath = raw_input("please input a remote path you want to upload:").strip()
    upload_file(localfile, rpath)
    check_file(rpath)
def addkeys(lfile,remotepath):
    put(lfile,remotepath)
    cmd = "cat "+ lfile +" >> .ssh/authorized_keys"
    run(cmd)
    check_file("/home/ubuntu/.ssh/authorized_keys")
def check_logs():
    cmd = "zmore /var/log/nginx/frontend-access.log.2.gz  | awk '{if ($8==\"400\") print $0}' > $HOME/`hostname`.log"
    run(cmd)
    get('*.log')
def check_logrotate():
    cmd ="cat /etc/logrotate.d/nginx"
    run(cmd)
def check_keys():
    cmd = " grep emma /home/ubuntu/.ssh/authorized_keys"
    run(cmd)
