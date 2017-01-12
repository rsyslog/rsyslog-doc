omfile: Text File Output Module
###############################

================  ===========================================================================
**Module Name:**  **omfile**
**Author:**       `Rainer Gerhards <http://www.gerhards.net/rainer>`_ <rgerhards@adiscon.com>
================  ===========================================================================

The omfile plugin provides the needed functionality to write messages to a local file.

Configuration Parameters
************************

Omfile is a built-in module that does not need to be loaded for default settings.
In order to specify module parameters, it must be loaded using:

    module(load="builtin:omfile" [parameters])

As can be seen in the parameters below, owner and groups can be set either by
name or by id (*uid, gid*). While using a name is more convenient, using
the id is more robust. There may be some situations where the OS is not able
to do the name-to-id resolution and -in these cases- the owner information will be
set to defaults. This seems to be uncommon and depends on the
authentication provider and service start order. In general, using names
is fine.

**TODO according to @davidelang this is insecure https://github.com/rsyslog/rsyslog-doc/pull/294#pullrequestreview-14280545**
Also, consider *octalNumber* values must always be a 4-digit octal number, with the initial digit being zero.
Mind that actual permission depend on rsyslogd's process umask. If in doubt, use "$umask 0000" right at the beginning of the
configuration file to remove any restrictions.

Module Parameters
=================

=========  ==========================
template:  "template-name"
Default:   RSYSLOG_FileFormat
Legacy:    $ActionFileDefaultTemplate
=========  ==========================

Set the default template to be used if an action is not configured to use a specific template.

===============  ==================
fileCreateMode:  "octalNumber"
Default:         0644
===============  ==================

Sets the default file creation mask to be used for an action if no explicit one is specified.

==========  ==============================
fileOwner:  "username"
Default:    current user (running Rsyslog)
==========  ==============================

Sets the default file owner name to be used for an action if no explicit one is specified.

=============  ==============================
fileOwnerNum:  "uid (number)"
Default:       current user (running Rsyslog)
=============  ==============================

Sets the default file owner (*uid*) to be used for an action if no explicit one is specified.

==========  ============================================
fileGroup:  "groupname"
Default:    current user (running Rsyslog) primary group 
==========  ============================================

Sets the default file group name to be used for an action if no explicit one is specified.

=============  ============================================
fileGroupNum:  "gid (number)"
Default:       current user (running Rsyslog) primary group 
=============  ============================================

Sets the default file group (*gid*) to be used for an action if no explicit one is specified.

==============  ==================
dirCreateMode:  "octalNumber"
Default:        0700
==============  ==================

Sets the default directory creation mask to be used for an action if no explicit one is specified.

=========  ==============================
dirOwner:  "username"
Default:   current user (running Rsyslog)
=========  ==============================

Sets the default directory owner name to be used for an action if no explicit one is specified.

============  ==============================
dirOwnerNum:  "uid (number)"
Default:      current user (running Rsyslog)
============  ==============================

Sets the default directory owner (*uid*) to be used for an action if no explicit one is specified.

=========  ============================================
dirGroup:  "groupname"
Default:   current user (running Rsyslog) primary group 
=========  ============================================

Sets the default directroy group name to be used for an action if no explicit one is specified.

============  ============================================
dirGroupNum:  "gid (number)"
Default:      current user (running Rsyslog) primary group 
============  ============================================

Sets the default directory group (*gid*) to be used for an action if no explicit one is specified.
   
Action Parameters
=================

Note that **one and only one** of the parameters *file* or *dynaFile* must be specified.

========  ===============
file:     "/absolute/full/path/to/file"
Default:  none
========  ===============

This parameters set in which file will Rsyslog write. It will always write into the same file.

* If the file does not already exist, it is created.
* If the file already exists, new data is appended to it.

**Important:** Used files remain open until rsyslog exits or receives a HUP signal.
As this may conflict with external log file rotation, remember to send a HUP signal to Rsyslog process after the file has been rotated away.

=========  ===============
dynaFile:  "template-name"
Default:   none
=========  ===============

For each message, the file name is generated based on the given template, having full control over how to format filenames.
As with *file* parameter, generated paths should be like "/absolute/full/path/to/file".

A cache of recent files is kept. Note that this cache can consume quite some memory (especially if large buffer sizes are used).
For example, 1000 files with a 1M buffer and double-buffer enabled is 2GB of system memory (1000*1M*2).
Files are kept open as long as they stay inside the cache and they are removed from the cache:

* When a HUP signal is received.
* Event *closeTimeout* occurs.
* Cache runs out of space, in which case the least recently used entry is evicted.
   
Apart from generating invalid paths/filenames, the most common cause of this is permission problems.
Permission problems can be either traditional filesystem permissions (the files need to be able to be created after any privilege drop takes place), or they can be a security module like SELinux or AppArmor.

==================  ==================
dynaFileCacheSize:  "number"
Default:            "10"
Legacy:             $DynaFileCacheSize
==================  ==================

**Applies only if dynamic filenames are used.**

Specifies the number of files that will be kept open.
Note that this is a per-action parameter, so if you have
multiple dynafile actions, each of them have their individual caches
(which means the numbers sum up).

Ideally, the cache size exactly
matches the need. You can use :doc:`impstats <impstats>` to tune
this value.
Note that a *lower-than-needed* cache size may be a lot worse that a *bigger-than-needed*.

=========  =============================================
template:  "template-name"
Default:   same as module parameter (RSYSLOG_FileFormat)
Legacy:    use: ". /var/log/foo;template-name"
=========  =============================================

Sets the template to be used for this action.

================  ==============================
closeTimeout:     "number"
Default:          "0 if using *file*, 10 if using *dynaFile*"
Available since:  8.3.3
================  ==============================

Specifies after how many minutes of inactivity a file is
automatically closed.

Note that this functionality is implemented based on the  :doc:`janitor process <../../concepts/janitor>`.

=========  ===============
zipLevel:  "number"
Default:   "0"
Legacy:    $OMFileZipLevel
=========  ===============

If greater than 0, turns on gzip compression of the output file. The
higher the number, the better the compression, but also the more CPU
is required for zipping.

================  ========
veryRobustZip:    "on|off"
Default:          "off"
Available since:  7.3.0
================  ========

If *zipLevel* is greater than 0,
then this setting controls if extra headers are written to make the
resulting file extra hardened against malfunction. 

If set to *off*, data appended to previously unclean closed files may not be
accessible without extra tools, something usually bearable.
On the other hand, if set to *on*, the extra headers considerably degrade compression, resulting in files four to five times bigger.

Filesystem parameters
---------------------

==========  =============================
fileOwner:  "username"
Default:    *defined by module parameter*
Legacy:     $FileOwner
==========  =============================

Set the owner for **newly created files**. 
This setting does not affect the owner of already existing files.

The parameter is a user name, for which the userid is
obtained by rsyslogd during startup processing. Interim changes to
the user mapping are not detected.

================  =============================
fileOwnerNum:     "uid (number)"
Default:          *defined by module parameter*
Available since:  7.5.8, 8.1.4
================  =============================

Set the owner for **newly created files**.
This setting does not affect the owner of already existing files.

The parameter is a numerical ID, which is used regardless
of whether the user actually exists. This can be useful if the user
mapping is not available to rsyslog during startup.

==========  =============================
fileGroup:  "groupname"
Default:    *defined by module parameter*
Legacy:     $FileGroup
==========  =============================

Set the group for **newly created files**. 
This setting does not affect the group of already existing files.

The parameter is a group name, for which the groupid is
obtained by rsyslogd during startup processing. Interim changes to
the user mapping are not detected.

================  =============================
fileGroupNum:     "gid (number)"
Default:          *defined by module parameter*
Available since:  7.5.8, 8.1.4
================  =============================

Set the group for **newly created files**.
This setting does not affect the group of already existing files.

The parameter is a numerical ID, which is used regardless
of whether the group actually exists. This can be useful if the group
mapping is not available to rsyslog during startup.

===============  =============================
fileCreateMode:  "octalnumber"
Default:         *defined by module parameter*
Legacy:          $FileCreateMode
===============  =============================

Allows to specify the file creation mask with which rsyslogd creates new files.
If not specified, the module configuration is used.

===================  ===================
failOnChOwnFailure:  "on|off"
Default:             "on"
Legacy:              $FailOnCHOwnFailure
===================  ===================

This option modifies behaviour of file creation.

If different owners or groups are specified for new files or directories, and rsyslogd fails to set them:

* If set to *on*, it will log an error and NOT write to the file.
* If it is set to *off*, the error will be ignored and processing continues.
  Keep in mind that in the event of an error, rsyslog may not be able to write on file.

===========  ===========
createDirs:  "on|off"
Default:     "on"
Legacy:      $CreateDirs
===========  ===========

Create directories on an as-needed basis

==============  =============================
dirCreateMode:  "octalnumber"
Default:        *defined by module parameter*
Legacy:         $DirCreateMode
==============  =============================

The same as fileCreateMode, but for automatically generated directories.

=========  =============================
dirOwner:  "username"
Default:   *defined by module parameter*
Legacy:    $DirOwner
=========  =============================

Set the owner for **newly created directories**. 
This setting does not affect the owner of already existing directories.

The parameter is a user name, for which the userid is
obtained by rsyslogd during startup processing. Interim changes to
the user mapping are not detected.

================  =============================
dirOwnerNum:      "uid (number)"
Default:          *defined by module parameter*
Available since:  7.5.8, 8.1.4
================  =============================

Set the owner for **newly created directories**.
This setting does not affect the owner of already existing directories.

The parameter is a numerical ID, which is used regardless
of whether the user actually exists. This can be useful if the user
mapping is not available to rsyslog during startup.

=========  =============================
dirGroup:  "groupname"
Default:   *defined by module parameter*
Legacy:    $DirGroup
=========  =============================

Set the group for **newly created directories**.
This setting does not affect the group of already existing directories.
   
The parameter is a group name, for which the groupid is obtained by
rsyslogd on during startup processing. Interim changes to the user
mapping are not detected.

============  =============================
dirGroupNum:  "gid (number)"
Default:      *defined by module parameter*
============  =============================

Set the group for **newly created directories**.
This setting does not affect the group of already existing directories.

The parameter is a numerical ID, which is used regardless
of whether the group actually exists. This can be useful if the group
mapping is not available to rsyslog during startup.

Expert parameters
-----------------

**If you're not familiar with rsyslog internals, that is a good indication that you should NOT use these parameters.**

**They almost never need to be changed, even on high load systems, so benchmarks should be run before and after changing any of them because sometimes they could lead to undesired non-intuitive performance impact.**

==============  ====================
flushInterval:  "seconds"
Default:        "1"
Legacy:         $OMFileFlushInterval
==============  ====================

Defines, in seconds, the interval after which unwritten data is flushed.

=============  ===================
asyncWriting:  "on|off"
Default:       "off"
Legacy:        $OMFileASyncWriting
=============  ===================

If turned *on*, the files will be written in asynchronous mode via a
separate thread. In that case, double buffers will be used so that
one buffer can be filled while the other buffer is being written.
Mind that if using *dynaFile* and this parameter is turned *on*, it can result in **a lot** of rsyslog threads (one per file currently open).
   
Note that in order to enable *flushInterval*, this parameter must be *on*. Otherwise, the flush interval will be ignored.
Also note that when flushOnTXEnd is *on* but asyncWriting is *off*, output will only be written when the buffer is full.
This may take several hours, or even require a rsyslog shutdown. However, a buffer flush can be forced in that case by sending rsyslogd a HUP signal.

=============  ===================
flushOnTXEnd:  "on|off"
Default:       "on"
Legacy:        $OMFileFlushOnTXEnd
=============  ===================

Omfile has the capability to write output using a buffered writer.
Disk writes are only done when the buffer is full. So if an error
happens during that write, data is potentially lost.

In cases where this is unacceptable, set this parameter to *on*.
Then, data is written at the end of each transaction (for pre-v5 this means after each log
message) and the usual error recovery thus can handle write errors
without data loss. 
Note that this option severely reduces the effect
of zip compression and should be switched to *off* for that use case.

=============  ===================
ioBufferSize:  "size"
Default:       "4K" (KB)
Legacy:        $OMFileIOBufferSize
=============  ===================

Size (in KB) of the buffer used to write output data. The larger the
buffer, the potentially better performance is. The default of 4K is
quite conservative, it is useful to go up to 64k, and 128K if you
used gzip compression (then, even higher sizes may make sense).

========  ========
sync:     "on|off"
Default:  "off"
========  ========

Enables file syncing capability.

When enabled, rsyslog does a sync to the data file as well as the
directory it resides after processing each batch. There currently
is no way to sync only after each n-th batch.

**Enabling sync causes a severe performance hit**.
Actually, it slows omfile down so much, that the probability of loosing messages increases.

In short, you should enable syncing only if you know exactly what you do, and fully understand how the rest of the engine works, and have tuned the rest of the engine to lossless operations.

Log signing and encryption
^^^^^^^^^^^^^^^^^^^^^^^^^^

**TODO I still have to review this**
   One needs to be careful with log rotation if signatures and/or
   encryption are being used. These create side-files, which form a set
   and must be kept together.
   For signatures, the ".sigstate" file must NOT be rotated away if
   signature chains are to be build across multiple files. This is
   because .sigstate contains just global information for the whole file
   set. However, all other files need to be rotated together. The proper
   sequence is to

   #. move all files inside the file set
   #. only AFTER this is completely done, HUP rsyslog

   This sequence will ensure that all files inside the set are
   atomically closed and in sync. HUPing only after a subset of files
   have been moved results in inconsistencies and will most probably
   render the file set unusable.
   
=============  ==============
sig.provider:  "providername"
Default:       none
=============  ==============

Selects a signature provider for **log signing**. By selecting a provider, the signature feature is turned on.

Currently, there are two providers available ":doc:`gt <sigprov_gt>`" and ":doc:`ksi <sigprov_ksi>`". 

**TODO still pending review `Sign log messages through signature provider Guardtime <http://www.rsyslog.com/how-to-sign-log-messages-through-signature-provider-guardtime/>`_**

=============  ==============
cry.provider:  "providername"
Default:       none
=============  ==============

Selects a cryptographic provider for **log encryption**. By selecting a provider, the encryption feature is turned on.

Currently, there only is one provider called ":doc:`gcry <../cryprov_gcry>`".

Examples
********
::

  # Write to myfile
  action(type="omfile" dirCreateMode="0700" fileCreateMode="0644" file="/var/log/myfile")

Legacy Configuration
====================

::

  # Write all messages into /var/log/messages
  $DirCreateMode 0700
  $FileCreateMode 0644
  *.* /var/log/messages
  
  # Write messages into /logs/mylog with a template
  *.* /logs/mylog;mytemplate
  
  $ResetConfigVariables # Resets all configuration variables to their default value.

Build
*****

In order to use omfile, configure must be run with parameter *--enable-omfile*


**TODO**
*  **$OMFileForceCHOwn** equivalent to the "ForceChOwn" parameter
*  **$ActionFileEnableSync** equivalent to the "enableSync" parameter
