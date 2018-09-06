******************************
imtcp: TCP Syslog Input Module
******************************

===========================  ===========================================================================
**Module Name:**             **imtcp**
**Author:**                  `Rainer Gerhards <https://rainer.gerhards.net/>`_ <rgerhards@adiscon.com>
===========================  ===========================================================================


Purpose
=======

Provides the ability to receive syslog messages via TCP. Encryption is
natively provided by selecting the approprioate network stream driver
and can also be provided by using `stunnel <rsyslog_stunnel.html>`_ (an
alternative is the use the `imgssapi <imgssapi.html>`_ module).


Notable Features
================

- :ref:`imtcp-statistic-counter`


Configuration Parameters
========================

.. note::

   Parameter names are case-insensitive.


Module Parameters
-----------------

AddtlFrameDelimiter
^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "-1", "no", "``$InputTCPServerAddtlFrameDelimiter``"

.. versionadded:: 4.3.1

This directive permits to specify an additional frame delimiter for
Multiple receivers may be configured by specifying $InputTCPServerRun
multiple times.


DisableLFDelimiter
^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "off", "no", "``$InputTCPServerDisableLFDelimiter``"

Industry-strandard plain text tcp syslog uses the LF to delimit
syslog frames. However, some users brought up the case that it may be
useful to define a different delimiter and totally disable LF as a
delimiter (the use case named were multi-line messages). This mode is
non-standard and will probably come with a lot of problems. However,
as there is need for it and it is relatively easy to support, we do
so. Be sure to turn this setting to "on" only if you exactly know
what you are doing. You may run into all sorts of troubles, so be
prepared to wrangle with that!


MaxFrameSize
^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "200000", "no", "none"

When in octet counted mode, the frame size is given at the beginning
of the message. With this parameter the max size this frame can have
is specified and when the frame gets to large the mode is switched to
octet stuffing.
The max value this parameter can have was specified because otherwise
the integer could become negative and this would result in a
Segmentation Fault. (Max Value = 200000000)


NotifyOnConnectionClose
^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "off", "no", "``$InputTCPServerNotifyOnConnectionClose``"

Instructs imtcp to emit a message if the remote peer closes a
connection.

**Important:** This directive is global to all listeners and must be
given right after loading imtcp, otherwise it may have no effect.


KeepAlive
^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "off", "no", "``$InputTCPServerKeepAlive``"

Enable of disable keep-alive packets at the tcp socket layer. The
default is to disable them.


KeepAlive.Probes
^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "0", "no", "``$InputTCPServerKeepAlive_probes``"

The number of unacknowledged probes to send before considering the
connection dead and notifying the application layer. The default, 0,
means that the operating system defaults are used. This has only
effect if keep-alive is enabled. The functionality may not be
available on all platforms.


KeepAlive.Time
^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "0", "no", "``$InputTCPServerKeepAlive_time``"

The interval between the last data packet sent (simple ACKs are not
considered data) and the first keepalive probe; after the connection
is marked to need keepalive, this counter is not used any further.
The default, 0, means that the operating system defaults are used.
This has only effect if keep-alive is enabled. The functionality may
not be available on all platforms.


FlowControl
^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "on", "no", "``$InputTCPFlowControl``"

This setting specifies whether some message flow control shall be
exercised on the related TCP input. If set to on, messages are
handled as "light delayable", which means the sender is throttled a
bit when the queue becomes near-full. This is done in order to
preserve some queue space for inputs that can not throttle (like
UDP), but it may have some undesired effect in some configurations.
Still, we consider this as a useful setting and thus it is the
default. To turn the handling off, simply configure that explicitely.


MaxListeners
^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "20", "no", "``$InputTCPMaxListeners``"

Sets the maximum number of listeners (server ports) supported.
This must be set before the first $InputTCPServerRun directive.


MaxSessions
^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "200", "no", "``$InputTCPMaxSessions``"

Sets the maximum number of sessions supported. This must be set
before the first $InputTCPServerRun directive.


StreamDriver.Name
^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "none"

Selects :doc:`network stream driver <../../concepts/netstrm_drvr>`
for all inputs using this module.


StreamDriver.Mode
^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "0", "no", "``$InputTCPServerStreamDriverMode``"

Sets the driver mode for the currently selected
:doc:`network stream driver <../../concepts/netstrm_drvr>`.
<number> is driver specific.


StreamDriver.AuthMode
^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "``$InputTCPServerStreamDriverAuthMode``"

Sets permitted peer IDs. Only these peers are able to connect to
the listener. <id-string> semantics depend on the currently
selected AuthMode and
:doc:`network stream driver <../../concepts/netstrm_drvr>`.
PermittedPeers may not be set in anonymous modes.


PermittedPeer
^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "array", "none", "no", "``$InputTCPServerStreamDriverPermittedPeer``"

Sets permitted peer IDs. Only these peers are able to connect to
the listener. <id-string> semantics depend on the currently
selected AuthMode and
:doc:`network stream driver <../../concepts/netstrm_drvr>`.
PermittedPeer may not be set in anonymous modes. PermittedPeer may
be set either to a single peer or an array of peers either of type
IP or name, depending on the tls certificate.

Single peer:
PermittedPeer="127.0.0.1"

Array of peers:
PermittedPeer=["test1.example.net","10.1.2.3","test2.example.net","..."]


DiscardTruncatedMsg
^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "off", "no", "none"

Normally when a message is truncated in octet stuffing mode the part that
is cut off is processed as the next message. When this parameter is activated,
the part that is cut off after a truncation is discarded and not processed.


gnutlsPriorityString
^^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "none"

.. versionadded:: 8.29.0

The GnuTLS priority strings specify the TLS session's handshake algorithms and
options. These strings are intended as a user-specified override of the library
defaults. If this parameter is NULL, the default settings are used. More
information about priority Strings
`here <https://gnutls.org/manual/html_node/Priority-Strings.html>`_.


PreserveCase
^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "boolean", "on", "no", "none"

.. versionadded:: 8.37.0

This parameter is for controlling the case in fromhost.  If preservecase is set to "off", the case in fromhost is not preserved.  E.g., 'host1.example.org' the message was received from 'Host1.Example.Org'.  Default to "on" for the backword compatibility.


Input Parameters
----------------

Port
^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "yes", "``$InputTCPServerRun``"

Starts a TCP server on selected port


Address
^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "none"

On multi-homed machines, specifies to which local address the
listerner should be bound.


Name
^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "imtcp", "no", "``$InputTCPServerInputName``"

Sets a name for the inputname property. If no name is set "imtcp" is
used by default. Setting a name is not strictly necessary, but can be
useful to apply filtering based on which input the message was
received from.


Ruleset
^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "``$InputTCPServerBindRuleset``"

Binds the listener to a specific :doc:`ruleset <../../concepts/multi_ruleset>`.


SupportOctetCountedFraming
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "binary", "on", "no", "``$InputTCPSupportOctetCountedFraming``"

If set to "on", the legacy octed-counted framing (similar to RFC5425
framing) is activated. This should be left unchanged until you know
very well what you do. It may be useful to turn it off, if you know
this framing is not used and some senders emit multi-line messages
into the message stream.


RateLimit.Interval
^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "0", "no", "none"

Specifies the rate-limiting interval in seconds. Default value is 0,
which turns off rate limiting. Set it to a number of seconds (5
recommended) to activate rate-limiting.


RateLimit.Burst
^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "integer", "10000", "no", "none"

Specifies the rate-limiting burst in number of messages. Default is
10,000.


listenPortFileName
^^^^^^^^^^^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "string", "none", "no", "none"

.. versionadded:: 8.38.0

With this parameter you can specify the name for a file. In this file the
port, imtcp is connected to, will be written.
This parameter was introduced because the testbench works with dynamic ports.

.. note::

   If this parameter is set, 0 will be accepted as the port. Otherwise it
   is automatically changed to port 514



.. _imtcp-statistic-counter:

Statistic Counter
=================

This plugin maintains :doc:`statistics <../rsyslog_statistic_counter>` for each listener. The statistic is named
after the given input name (or "imtcp" if none is configured), followed by
the listener port in parenthesis. For example, the counter for a listener
on port 514 with no set name is called "imtcp(514)".

The following properties are maintained for each listener:

-  **submitted** - total number of messages submitted for processing since startup


Caveats/Known Bugs
==================

-  module always binds to all interfaces
-  can not be loaded together with `imgssapi <imgssapi.html>`_ (which
   includes the functionality of imtcp)


Examples
========

Example 1
---------

This sets up a TCP server on port 514 and permits it to accept up to 500
connections:

.. code-block:: none

   module(load="imtcp" MaxSessions="500")
   input(type="imtcp" port="514")


Note that the global parameters (here: max sessions) need to be set when
the module is loaded. Otherwise, the parameters will not apply.


Additional Resources
====================

- `rsyslog video tutorial on how to store remote messages in a separate file <http://www.rsyslog.com/howto-store-remote-messages-in-a-separate-file/>`_ (for legacy syntax, but you get the idea).

