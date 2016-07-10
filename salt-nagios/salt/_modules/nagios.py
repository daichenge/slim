#!/usr/bin/python
import salt.client
import commands
def get_clients():
  local = salt.client.LocalClient()
  client_info = local.cmd('*', [
    'grains.items'
    ], [
    []
    ])
  client_dict = {}
  for key,items in client_info.iteritems():
     client_id = items['grains.items']['id']
     client_ip = items['grains.items']['ipv4'][1]
     client_dict[client_id] = client_ip
  return client_dict
def get_retire():
  local = salt.client.LocalClient()
  client_info = local.cmd('*', [
    'grains.items'
    ], [
    []
    ])
  client_list = [ items['grains.items']['id'] for items in client_info.values() ]
  files_list=commands.getoutput('ls /etc/nagios3/servers').split('\n')
  filename= [ i.replace('.cfg','') for i in files_list ]
  retire_list = list(set(filename) ^ set(client_list))
  return retire_list
