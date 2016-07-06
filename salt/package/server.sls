nagios-package:
  pkg.installed:
    - pkgs:
       - nagios3
       - nagios-nrpe-plugin
       - nagios-nrpe-server
       - vim
       - ndoutils-common
       - pnp4nagios

nagios-nrpe-files:
  file.managed:
    - name: /etc/nagios/nrpe.cfg
    - source: salt://package/files/nrpe.cfg
    - mkdirs: True

nagios-main:
  file.managed:
    - name: /etc/nagios3/nagios.cfg
    - source: salt://package/files/nagios/nagios.cfg

nagios-conf-files:
  file.recurse:
    - name: /etc/nagios3/conf.d
    - source: salt://package/files/nagios/conf.d

nagios-server-list:
  file.recurse:
    - name: /etc/nagios3/servers
    - source: salt://package/files/nagios/servers
    - mkdirs: True

npcd-config:
  file.managed:
    - name: /etc/default/npcd
    - source: salt://package/files/npcd
    - mkdirs: True

ndoutils-config:
  file.managed:
    - name: /etc/default/ndoutils
    - source: salt://package/files/ndoutils
    - mkdirs: True

apache-config:
  file.managed:
    - name: /etc/nagios3/htpasswd.users
    - source: salt://package/files/htpasswd.users
    - mkdirs: True

apache-pnp4-config:
  file.managed:
    - name: /etc/apache2/conf-enabled/pnp4nagios.conf
    - source: salt://package/files/pnp4nagios.conf
    - mkdirs: True

nagios-server:
  service.running:
    - name: nagios3
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nagios3/nagios.cfg

npcd:
  service.running:
    - name: npcd
    - enable: True
    - reload: True
    - watch:
      - file: /etc/default/npcd

ndoutils:
  service.running:
    - name: npcd
    - enable: True
    - restart: True
    - watch:
      - file: /etc/default/ndoutils

apache:
  service.running:
    - name: apache2
    - enable: True
    - restart: True
    - watch:
      - file: /etc/nagios3/htpasswd.users

nagios-nrpe-server:
  service.running:
    - name: nagios-nrpe-server
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nagios/nrpe.cfg
