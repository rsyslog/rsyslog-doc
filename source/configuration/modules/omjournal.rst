*********************************
omjournal: Systemd Journal Output
*********************************

===========================  ===========================================================================
**Module Name:**             **omjournal**
**Author:**                  `Rainer Gerhards <https://rainer.gerhards.net/>`_ <rgerhards@adiscon.com>
===========================  ===========================================================================


Purpose
=======

This module provides native support for logging to the systemd journal.


Configuration Parameters
========================

.. note::

   Parameter names are case-insensitive.


Action Parameters
-----------------

Template
^^^^^^^^

.. csv-table::
   :header: "type", "default", "mandatory", "|FmtObsoleteName| directive"
   :widths: auto
   :class: parameter-table

   "word", "none", "no", "none"

Template to use when submitting messages.

By default, rsyslog will use the incoming %msg% as the MESSAGE field
of the journald entry, and include the syslog tag and priority.

You can override the default formatting of the message, and include
custom fields with a template. Complex fields in the template
(eg. json entries) will be added to the journal as json text. Other
fields will be coerced to strings.

Journald requires that you include a template parameter named MESSAGE.


Examples
========

Example 1
---------

The following sample writes all syslog messages to the journal with a
custom EVENT_TYPE field.

.. code-block:: none

   module(load="omjournal")

   template(name="journal" type="list") {
     constant(value="Something happened" outname="MESSAGE")
     property(name="$!event-type" outname="EVENT_TYPE")
   }

   action(type="omjournal" template="journal")


