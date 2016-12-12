pmrfc3164: Parse RFC3164-formatted messages
===========================================

Author: Rainer Gerhards

This parser module is for parsing messages according to the traditional/legacy 
syslog standard :rfc:`3164`

It is part of the default parser chain.

The parser can also be customized to allow the parsing of specific formats, 
if they occur.

Parser Parameters
-----------------

.. function:: permit.squareBracketsInHostname <boolean>

   **Default**: off

   This setting tells the parser that hostnames that are enclosed by brackets
   should omit the brackets.

.. function:: permit.slashesInHostname <boolean>

   **Default**: off

   Available since: 8.20.0

   This setting tells the parser that hostnames may contain slashes. This
   is useful when messages e.g. from a syslog-ng releay chain are received.
   Syslog-ng puts the various relay hosts via slashes into the hostname
   field.

.. function:: permit.arobasesInHostname <boolean>

   **Default**: off

   Available since: 8.24.0

   This setting tells the parser that hostnames may contain arobases. This
   is useful when messages are relayed from a syslog-ng server in rfc3164
   format. The hostname field sent by syslog-ng may be prefixed by the source
   name followed by an arobase character.

.. function:: force.tagEndingByColon <boolean>

   **Default**: off

   Available since: 8.24.0

   This setting tells the parser that tag need to be ending by colon to be valid.
   In others case, the tag is the first word of the message and the tag is left
   empty.

.. function:: detect.YearAfterTimestamp <boolean>

   **Default**: off

   Some devices send syslog messages in a format that is similar to RFC3164, 
   but they also attach the year to the timestamp (which is not compliant to
   the RFC). With regular parsing, the year would be recognized to be the 
   hostname and the hostname would become the syslogtag. This setting should 
   prevent this. It is also limited to years between 2000 and 2099, so 
   hostnames with numbers as their name can still be recognized correctly. But
   everything in this range will be detected as a year.
   
Example
-------
We assume a scenario where some of the devices send malformed RFC3164
messages. The parser module will automatically detect the malformed
sections and parse them accordingly. 

::

   module(load="imtcp")
   
   input(type="imtcp" port="514" ruleset="customparser")

   parser(name="custom.rfc3164" 
   	 type="pmrfc3164"
   	 permit.squareBracketsInHostname="on"
   	 detect.YearAfterTimestamp="on")

   ruleset(name="customparser" parser="custom.rfc3164") {
   	 ... do processing here ...
   }

