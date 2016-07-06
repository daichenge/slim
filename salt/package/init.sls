include:
{% if grains['id'] == 'local' %}
  - package.server
{% else %}
  - package.client
{% endif %}
