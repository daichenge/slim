include:
{% if grains['id'] == 'local' %}
  - package.server
  - package.finder
  - package.retire
{% else %}
  - package.client
{% endif %}
