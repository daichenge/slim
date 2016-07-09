include:
{% if grains['id'] == 'local' %}
  - package.server
  - package.finder
{% else %}
  - package.client
{% endif %}
