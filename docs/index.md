# WooCommerce Core Test Reports

- [REST API Tests](./api/)
  - [Daily smoke tests](./api/daily/)
  - [Releases](./api/release/)
  - [Pull requests](./api/pr/)
- [E2E Tests](./e2e/)
  - [Daily smoke tests](./e2e/daily/)
  - [Releases](./e2e/release/)
  - [Pull requests](./e2e/pr/)
{% for page in site.pages %}
   {% if page contains "/e2e/pr/" %}
    - [{{ page.url | remove: "/e2e/pr/"}}](.{{ page.url }})
   {% endif %}
{% endfor %}
