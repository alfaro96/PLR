:mod:`{{ module }}`.{{ objname }}
{{ underline }}========

.. currentmodule:: {{ module }}

.. autoclass:: {{ objname }}

    {% block methods %}
    .. rubric:: Methods

    {% if methods %}
    .. autosummary::
    {% for item in methods %}
        {% if item != "__init__" %}
        ..
        ~{{ name }}.{{ item }}
        {% endif %}
    {% endfor %}
    {% endif %}
    {% endblock %}
