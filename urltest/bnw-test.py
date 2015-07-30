'''
Created on Jul 30, 2015

@author: Slim Dai
'''
import urllib2
import socket
import re
import ConfigParser
def get_ba(furi,envs):
    config = ConfigParser.ConfigParser()
    config.read("bnw-config.conf")
    buser = config.get("ba","user")
    bpass = config.get("ba","passwd")
    if envs == 'demo':
        tips = config.get("ba","demotips")
    else:
        tips = config.get("ba","stagetips")
    auth_hand = urllib2.HTTPBasicAuthHandler()
    auth_hand.add_password(realm = tips, uri = furi,user= buser,passwd = bpass)
    opener = urllib2.build_opener(auth_hand)
    return opener
def frontend_check(env):
    socket.setdefaulttimeout(10)
    if env == 'prod':
        response = urllib2.urlopen("http://www.testscript.com", timeout = 10)
    else:
        furl = "http://www-" + env + ".testscript.com"
        urllib2.install_opener(get_ba(furl,env))
        response = urllib2.urlopen(furl + '/global-en/' , timeout=10)
    m = re.findall('insert you want to lookup', response.read())
    if len(m) > 0 and env != "demo":
        print "There are ", len(m), "  found on the page.Please check!!!!!!"
    elif len(m) > 0 and env == "demo":
        print "You are in demo env now!"
    else:
        print "You are in ", env, " now!"
    print "The result for curl is as below:"
    print "--------------------------------------"
    print "HTTP: " , response.getcode()
    print response.info()

