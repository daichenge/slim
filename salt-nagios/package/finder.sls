{% set clients = salt['nagios']['get_clients']() %}
{% for id,ip in clients.iteritems() %}
nagios-list-{{ id }}:
  file.managed:
    - name: /etc/nagios3/servers/{{ id }}.cfg
    - source: salt://package/files/nagios/servers/template.cfg
    - mkdirs: True
    - template: jinja
    - defaults:
        nid: {{ id }}
        nip: {{ ip }}
{% endfor %}
