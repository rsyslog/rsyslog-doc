Configuration Formats
=====================

Rsyslog has evolved over several decades. For this reason it supports three
different configuration formats ("languages"):

-  :doc:`basic <sysklogd_format>` - this is the format best use to express
   basic things. It stems back to the original syslog.conf format, in use now
   for several decades.  It is taught everywhere and still useful for basic use
   cases like writing to log files.
-  **advanced** - the new style format, specifically targeted towards more
   advanced use cases like forwarding to remote hosts that might be partially offline.
   This format is available in rsyslog v6 and above.
-  **obsolete** - this format is exactly what its name implies: it is obsolete
   and should not be used when writing new configurations. It was created in the
   early days (up to rsyslog version 5) where we expected that rsyslog would extend
   sysklogd just mildly.  Consequently, it was primarily aimed at small additions
   to the original sysklogd format. Practice has shown that it was notoriously hard
   to use for more advanced use cases, and thus we replaced it with **advanced** format.


Which Format should I Use?
~~~~~~~~~~~~~~~~~~~~~~~~~~

Rsyslog supports all formats concurrently, so you can pick either
basic or advanced format. Just be warned to stay away from obsolete
format, even though you can technically include it into the same
config as well.

**For very basic things basic format is still suggested**,
especially if the full config consists of such basic things. The
classical sample is writing to files (or forwarding) via priority.
In basic format, this looks like::

   mail.info /var/log/mail.log
   mail.err @@server.example.net

This is hard to beat in simplicity, still being taught in courses
and a lot of people know this syntax. It is perfectly fine to use
these constructs even in newly written config files. Note that many
distributions use this format in their default rsyslog.conf. So you
will likely find it in existing configurations.

**For anything more advanced, use advanced format.** Advantages are:

- fine control over rsyslog operations via advanced parameters
- easy to follow block structure
- easy to write and understand

To continue with the above example, advanced format is preferrable if you
want to make sure that an offline remote destination will not slow down
local log file writing. In that case, forwarding better is done via::

   mail.err action(type="omfwd" protocol="tcp" queue.type="linkedList")

As can be seen, advanced format permits to specify additional parameters.
This enables activation of advanced features.

**Do not use obsolete format. It will make your life miserable.**
It is primarily supported in order to not break existing
configurations. Whatever you can do with obsolete format, you can also do
with advanced format. The opposite is not true: Many newer features cannot be
turned on via obsolete format. Obsolete format is hard to understand
and hard to get right. As you may inherit a rsyslog configuration that makes
use of it, this documentation gives you some clues of what the obsolete
statements do. For full details, obtain a `v5 version of the rsyslog
documentation <http://www.rsyslog.com/doc/v5-stable/index.html>`_ (yes,
this format is dead since 2010!).
