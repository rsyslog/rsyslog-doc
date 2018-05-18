***************
parse_json_ex()
***************

Purpose
=======

parse_json_ex(str, container, compact)

When the given JSON string contains empty string, empty array, empty elements in array or empty JSON object,
they are eliminated if ``compact`` is set to "true".

Example
=======

In the following example, the parsed and processed JSON is placed into the variable $!parsed.
The output is placed in variable $.ret.

.. code-block:: none

   set $.ret = parse_json_ex("{ \"message\":\"Test message\",\"log_level\":\"INFO\",
                                \"time\":\"2018-06-03T17:43:26.653959-06:00\",
                                \"key0\":\"\", \"key1\":[], \"key2\":{} }", "\$!parsed", "true");

The content of $!parsed:

.. code-block:: none

   { "message": "Test message", "log_level": "INFO", "time": "2018-06-03T17:43:26.653959-06:00" }
