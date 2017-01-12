.. index:: ! imfile

imfile: Text File Input Module
##############################

================  ===========================================================================
**Module Name:**  **imfile**
**Author:**       `Rainer Gerhards <http://www.gerhards.net/rainer>`_ <rgerhards@adiscon.com>
================  ===========================================================================

Use this module to read **text files** to process them on rsyslog.
In a text file:

* lines have printable characters
* lines are delimited by *LF*

Please, notice we talk about **reading text lines, not syslog messages stored on a file**, therefore it makes sense to have parameters to set *tag, priority or severity*.

Files are read line-by-line **ignoring any empty lines**, and rsyslog keeps information about *last reading position* in what's called **state files**.

State files
***********

State files are used to store the last reading position of a file and they are 
named like ``imfile-state:*full-path-filename*`` replacing all occurrences of "/" by "-". 

eg: monitoring file ``/var/log/applog`` will be done in ``imfile-state:-var-log-applog``.

These files are always created in the rsyslog working directory. If :doc:`WorkDirectory <../global/index>` is not set or set to a non-writable location, the state file **won't be generated**.
In those cases, the file content will always be completely re-sent by imfile, 
because the module does not know the last reading position.

Older rsyslog versions had a *stateFile* parameter, but it had several 
drawbacks and it's now deprecated.

Monitoring for changes supports file rotation under some circunstances:

* rsyslog must be running while file is rotated, otherwise lines after last reading position won't be processed
* once rsyslog ends with remaining lines, it will start reading new file from the beginning.

Have in mind that files aren't monitored using paths, but have a *file handler* which doesn't change if file is renamed.

Module Parameters
*****************

================  ==================
mode:             "inotify|polling"
Default:          "inotify"
Legacy:           $InputFileReadMode
Available since:  8.1.5
================  ==================

This specifies if imfile is shall run in *inotify* or *polling* mode.

inotify: it works by registering with the OS to be notified when the file changes.

polling: it needs more resources and its slower than *inotify*, reason why **mode="inotify" is recommended** if supported by your system.
Basically there's a timeout at which file is checked for changes.

================  ======================
pollinginterval:  "seconds"
Default:          "10"
Legacy:           $InputFilePollInterval
Available since:  8.1.5
================  ======================

This setting specifies how often files are checked for changes when using **mode="polling"**. Basically, this mean files are read and rsyslog sleeps for X seconds before being read again.

Although it's possible, its stongly recommend not to set it to 0 seconds, because in such scenario rsyslog will take far too many resources.

Input parameters
****************

============  ===============
**REQUIRED**
file:         "/path/to/file"
Default:      none
Legacy:       $InputFileName
============  ===============

File(s) being processed. This shall be an absolute file path (no macros or templates). 

This option currently supports *file wilcards* in **inotify mode only** (it hasn't been implemented for polling) for monitoring multiple files. Consider wildcards are only valid at directory level, ie:

* /path/to/file.log is valid and will monitor file named file.log
* /path/to/file\*.log is valid and will monitor all files named like *file\**.log
* /path/to/\*name.log is valid and will monitor all files named like *\*name*.log
* /path/to\*/file.log is invalid
* /path/to/foo being foo a directory is also invalid

============  =============
**REQUIRED**
tag:          "value"
Default:      none
Legacy:       $InputFileTag
============  =============

**TODO: preperly link Syslog Specification https://tools.ietf.org/html/rfc5424#section-6.2.5**

The tag or application name that originated the file (message), according to RFC. If you would like to see the colon after the tag, you need to specify it here (like 'tag="myTagValue:"').
 
=========  ==================
facility:  "value"
Default:   "local0"
Legacy:    $InputFileFacility
=========  ==================

**TODO: preperly link Syslog Specification https://tools.ietf.org/html/rfc5424#section-6.2.5**

The syslog facility to be assigned to lines read. Textual form is suggested (e.g. "local0", "local1", ...) but numbers are also accepted (e.g. 128 for "local0") as defined in RFC.

=========  ==================
severity:  "value"
Default:   "notice"
Legacy:    $InputFileSeverity
=========  ==================

**TODO: preperly link Syslog Specification https://tools.ietf.org/html/rfc5424#section-6.2.5**

The syslog severity to be assigned to lines read. Textual form is suggested (e.g. "info", "warning", ...) but numbers are also accepted (e.g. 4 for "info") as defined in RFC.

========  =====================
ruleset:  "ruleset-name"
Default:  none
Legacy:   $InputFileBindRuleset
========  =====================

**TODO link ruleset**
Binds the listener to a specific Ruleset.

============  =============================
addmetadata:  "on|off"
Default:      depending on file. See below.
============  =============================

This is used to turn *on/off* the addition of metadata to the
message object. Current supported metadata:

* filename: Name of the file where the message originated from. This is most useful when using wildcards inside file monitors, because it then is the only way to know which file the message originated from. **The value can be accessed using the %$!metadata!filename% property**.

By default, it's set to *on* if *file* contains *wildcards*, otherwise default is *off*.

==================  ====================
trimlineoverbytes:  "number"
Default:            "0 (never truncate)"
Available since:    8.17.0
==================  ====================

**This option can be used only when *readMode* is 0 or 2**.
This is used to tell rsyslog to truncate the line which length is greater
than specified bytes. If it is positive number, rsyslog truncate the line
at specified bytes. 

================  ========
freshstarttail:   "on|off"
Default:          "off"
Available since:  8.18.0
================  ========

If set to *off*, rsyslog will read files from *last read position* as defined in State files.
If set to *on*, rsyslog will seek the file reading position at the end/tail, processing new events written since that moment.
It's very useful when deploying rsyslog to a large number of servers, because it allows to discard old logs.

=====================  ==============================
persiststateinterval:  "number"
Default:               "0 (end rsyslog execution)"
Legacy:                $InputFilePersistStateInterval
=====================  ==============================

Specifies how often (lines read) the state file shall be written when processing the input file. 

If set to 0, it means a new state file is only written when the monitored files are closed (end of rsyslogd execution).
Any other value means that the state file is written when *number* lines have been processed.

This setting can be used to guard against message duplication due to fatal errors (like power fail).
Note that this setting affects imfile performance, especially when set to a low value. 

Multiline parameters
====================

=========  =======
readmode:  "0|1|2"
Default:   "0"
=========  =======

Provides support for *simple* multi-line processing. Incompatible with *startmsg.regex*. 

* 0 - line: each line is a new message.
* 1 - paragraph: there is a blank line between log messages.
* 2 - indented: new messages start at the beginning of a line. If a line starts with a space or tab ("\\t") it is part of the previous message.

**This paramater is deprecated. DO NOT use it, because it would be removed in future releases**.

================  =================
startmsg.regex:   "POSIX ERE regex"
Default:          none
Available since:  8.10.0
================  =================

This option allows more complex multi-line messages, using provided regex as a start of new messages. As it is using regular expressions, it's more flexible than *readMode* but at the cost of lower performance when working with complex regular expressions.

Note that *readMode* and *startmsg.regex* cannot both be defined for the same input.

See also: `POSIX ERE Syntax <https://en.wikipedia.org/wiki/Regular_expression#POSIX_extended>`_

================  ================
readtimeout:      "seconds"
Default:          "0 (no timeout)"
Available since:  8.23.0
================  ================

**Currently, it only works with *startmsg.regex*.**

When reading multi-line files, it is impossible to know if the last read line is the last of the message, cause next line hasn't been written yet (neither if there will be a next line or when it will be).
To prevent rsyslog waiting forever, this parameter was added in order to define a timeout to wait for new lines that could be part of current message.

If specified,
partial multi-line reads are timed out after the specified timeout interval.

To guard against accidential too-early emission of a (partial) message, the
timeout should be sufficiently large (5 to 10 seconds or more recommended).
Specifying a value of zero turns off timeout processing. Also note the
relationship to the *timeoutGranularity* parameter, which sets the
lower bound of *readTimeout*.

Setting timeout vaues slightly increases processing time requirements; the
effect should only be visible of a very large number of files is being
monitored.

===================  ================
timeoutgranularity:  "seconds"
Default:             "0 (no timeout)"
Available since:     8.23.0
===================  ================

This sets the interval in which multi-line-read timeouts are checked. Note that
this establishes a lower limit on the length of the timeout. For example, if
a timeoutGranularity of 60 seconds is selected and a readTimeout value of 10 seconds
is used, the timeout is nevertheless only checked every 60 seconds (if there is
no other activity in imfile). This means that the readTimeout is also only
checked every 60 seconds, which in turn means a timeout can occur only after 60
seconds.

Consider that timeGranularity has some performance implication. The more frequently
timeout processing is triggerred, the more processing time is needed. This
effect should be neglectible, except if a very large number of files are being
monitored.

================  ========
escapelf:         "on|off"
Default:          "on"
Available since:  7.5.3
================  ========

This expert setting is only meaningful if multi-line messages are to be processed.
LF characters embedded into syslog messages cause a lot of trouble,
as most tools and even the legacy syslog TCP protocol do not expect
these.

If set to *on*, this option avoid this trouble by properly
escaping LF characters to the 4-byte sequence "#012". This is
consistent with other rsyslog control character escaping.

If you turn it *off*, make sure you test very
carefully with all associated tools. 

Please note that if you intend
to use plain TCP syslog with embedded LF characters, you need to
enable octet-counted framing.

**Warning**: in order to preserve backward compatibility LF escaping in multiline messages is turned **off** for legacy-configured file monitors. It's highly suggested to use new syntax.

TODO For more details, see Rainer's blog posting on imfile LF escaping. 
**This? http://blog.gerhards.net/2013/09/imfile-multi-line-messages.html**

Expert parameters
=================

**
If you're not familiar with rsyslog internals, that is a good indication that you should NOT use these parameters.

They almost never need to be changed, even on high load systems, so benchmarks should be run before and after changing any of them because sometimes they could lead to undesired non-intuitive performance impact.
**

================  ========
maxsubmitatonce:  "number"
Default:          "1024"
================  ========

This is an expert option. It can be used to set the maximum input
batch size that imfile can generate. Be sure to understand
rsyslog message batch processing before you modify this option.

**If you do not know what this is about, that is a good
indication that you should NOT modify the default.**

========================  ========
deletestateonfiledelete:  "on|off"
Default:                  "on"
Available since:          8.5.0
========================  ========

This expert parameter controls if state files are deleted if their associated
main file is deleted. Usually, this is a good idea, because otherwise
problems would occur if a new file with the same name is created. In
that case, imfile would pick up reading from the last position in
the *deleted* file, which usually is not what you want.

However, there is one situation where not deleting associated state
file makes sense: this is the case if a monitored file is modified
with an editor (like vi or gedit). Most editors write out modifications
by deleting the old file and creating a new now. If the state file
would be deleted in that case, all of the file would be reprocessed,
something that's probably not intended in most case. As a side-note,
it is strongly suggested *not* to modify monitored files with
editors. In any case, in such a situation, it makes sense to
disable state file deletion. That also applies to similar use
cases.

**In general, this parameter should only by set if the users
knows exactly why this is required.**

Experimental parameters
=======================

=================  ========
reopenontruncate:  "on|off"
Default:           "off"
Available since:   8.16.0
=================  ========

**This is an experimental feature. DO NOT use it in production environments**

Tells rsyslog to reopen input file when it was truncated (inode unchanged but file size on disk is less than
current offset in memory).

Deprecated parameters
=====================

===============  ========================
maxlinesatonce:  "number"
Default:         "10240"
Legacy:          $InputFileMaxLinesAtOnce
===============  ========================

**This paramater is deprecated. DO NOT use it, because it would be removed in future releases**.

This is a legacy setting that is only supported in *polling* mode.
In *inotify* mode, it is fixed at 0 and all attempts to configure a different value 
will be ignored, but will show an error message.

In *polling* mode, if set to 0, each file will be fully processed before processing the next.
If it is set to any other value, a maximum of *number* lines are processed in sequence 
for each file, before checking the next. 

==============  ====================
statefile:      "name-of-state-file"
Default:        none
Legacy:         $InputFileStateFile
==============  ====================

**This paramater is deprecated. DO NOT use it, because it would be removed in future releases**.

Defines the state file name.

Examples
********

::

  # This line enable usage of imfile. Write it just once!
  module(load="imfile")

  # Following line read \*.log named files using a wilcard.
  # It also adds *%$!metadata!filename%* property to message
  input(file="/path/to/\*.log" tag="mytag" type="imfile" addmetadata="on")

  # In this case, module was loaded in polling mode
  module(load="imfile" mode="polling")

Legacy configuration
====================

::

  # Load module. Must be done just once!
  $ModLoad imfile 
  
  # Monitor file and set tag "mytag:"
  $InputFileName /path/to/file
  $InputFileTag mytag:
  $InputFileSeverity error
  $InputFileFacility local7
  $InputRunFileMonitor # tell Rsyslog to add an input **for current configuration**
  
  # Monitor another file
  $InputFileName /path/to/anotherfile.log
  $InputFileTag myothertag:
  # Set ruleset for this input
  $InputFileBindRuleset ruleset
  # Set polling mode
  $InputFileReadMode polling
  # Set polling interval to 5 seconds
  $InputFilePollInterval 5
  $InputRunFileMonitor # tell Rsyslog to add another input
