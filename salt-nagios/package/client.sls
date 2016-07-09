nagios-package:
  pkg.installed:
    - pkgs:
       - nagios-nrpe-server
       - vim

nagios-nrpe-files:
  file.managed:
    - name: /etc/nagios/nrpe.cfg
    - source: salt://package/files/nrpe.cfg
    - mkdirs: True


nagios-nrpe-server:
  service.running:
    - name: nagios-nrpe-server
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nagios/nrpe.cfg
