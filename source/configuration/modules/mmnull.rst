****************************************
mmnull: message modification module
****************************************

================  ==============================================================
**Module Name:**  **mmnull**
**Authors:**      Jean-Philippe Hilaire <jean-philippe.hilaire@pmu.fr> & Philippe Duveau <philippe.duveau@free.fr>
================  ==============================================================


Purpose
=======

 Its objectives are closed to this parser but as a message modification
 it can be used in a different step of the message processing without
 interfering in the parser chain process and can be applied before or
 after parsing process.
 
 Its purposes are :
 
 - to add a tag on message produce by input module which does not provide
   a tag like imudp or imtcp. Useful when the tag is used for routing the
   message.
   
 - to force message hostname to the rsyslog valeur. The use case is
   application in auto-scaling systems (AWS) providing logs through udp/tcp
   were the name of the host is based on an ephemeral IPs with a short term
   meaning. In this situation rsyslog local host name is generally the
   auto-scaling name then logs produced by the application is affected to
   the application instead of the ephemeral VM.

Compile
=======

To successfully compile mmnull module.

    ./configure --enable-mmnull ...

Configuration Parameters
========================

Tag
^^^

.. csv-table::
  :header: "type", "mandatory", "format", "default"
  :widths: auto
  :class: parameter-table

  "string", "no", ,"none"

The tag to be assigned to messages modified. If you would like to see the 
colon after the tag, you need to include it when you assign a tag value, 
like so: ``tag="myTagValue:"``.

If this attribute is no provided, messages tags are not modified.

ForceLocalHostname
^^^^^^^^^^^^^^^^^^

.. csv-table::
  :header: "type", "mandatory", "format", "default"
  :widths: auto
  :class: parameter-table

  "Binary", "no", ,"off"

This attribute force to set the HOSTNAME of the message to the rsyslog
value "localHostName". This allow to set a valid value to message received
received from local application through imudp or imtcp.

Sample
======

In this simple the message received is parsed by RFC5424 parser and then 
the HOSTNAME is overwritten and a tag is setted. 

.. code-block:: none

    module(load='mmnull')
    module(load='imudp')
    
    ruleset(name="TagUDP" parser=[ "rsyslog.rfc5424" ]) {
        action(type="mmnull" tag="udp" forcelocalhostname="on")
        call ...
    }
    input(type="imudp" port="514" ruleset="TagUDP")
