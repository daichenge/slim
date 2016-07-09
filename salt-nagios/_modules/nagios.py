#!/usr/bin/python
import salt.client
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
