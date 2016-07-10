{% set clients = salt['nagios']['get_retire']() %}
{% for client in clients %}
nagios-retire-{{ client }}:
  file.managed:
    - name: /etc/nagios3/servers/{{ client }}.cfg
    - source: salt://package/files/nagios/servers/retire-template.cfg
    - mkdirs: True
{% endfor %}
