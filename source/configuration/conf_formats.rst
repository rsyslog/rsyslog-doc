Choosing the Right Rsyslog Configuration Format
===============================================

Rsyslog, a versatile logging daemon, offers three configuration formats: **Basic**, **Advanced**, and **Obsolete Legacy**. While the Basic Format was once considered a viable option for simple configurations, it is now discouraged for all use cases.

Advanced Format: The Recommended Choice for All Scenarios
---------------------------------------------------------

The **Advanced Format**, formerly known as the RainerScript format, is the recommended choice for any rsyslog configuration. It provides enhanced control over rsyslog operations, making it the preferred format for all deployments, from simple to complex.

The Advanced Format is particularly well-suited for scenarios involving multiple log destinations, conditional routing, and detailed log handling. Its structured block syntax enhances readability and maintainability, while its support for include files simplifies configuration management.

Basic Format: A Discouraged Option
----------------------------------

The **Basic Format**, also known as the sysklogd format, is no longer recommended, even for simple configurations. Its limitations in terms of control, readability, and maintainability make it a less suitable choice for modern logging needs.

The Basic Format may still be present in legacy configurations, but it is strongly recommended to migrate to the Advanced Format to benefit from its enhanced capabilities.

Obsolete Legacy Format: Avoid for Maintainability and Readability
-----------------------------------------------------------------

The **Obsolete Legacy Format**, introduced in rsyslog versions 1 through 5, is no longer recommended for new or existing configurations. It was primarily designed to extend the capabilities of the original syslog.conf format but has proven difficult to use effectively for more advanced setups.

Due to its inherent limitations and lack of support for modern features, the Obsolete Legacy Format is discouraged for use. While it may still be present in legacy configurations, it is recommended to migrate to the Basic or Advanced formats for better maintainability and readability.

Conclusion: Embrace the Advanced Format for Enhanced Flexibility
----------------------------------------------------------------

With its enhanced control, readability, and support for modern features, the **Advanced Format** is the clear choice for all rsyslog configurations, regardless of their complexity.

The Basic Format can still be used if preferred, but its limitations make it less suitable for maintainable and scalable logging solutions.

As for the Obsolete Legacy Format, it should be eliminated altogether to ensure a modern and maintainable logging infrastructure.

Recommendations:
----------------

* **Adopt the Advanced Format as the default choice for all new and existing rsyslog configurations.**
* **Migrate from the Basic Format to the Advanced Format whenever possible.**
* **Eliminate the Obsolete Legacy Format to avoid its limitations and maintainability issues.**

By following these recommendations, you can ensure that your rsyslog configuration is both powerful and maintainable, providing a solid foundation for your logging needs.


ALTERNATE
=========


========================================
Revised Rsyslog Configuration Formats Guide
========================================

Overview of Rsyslog Configuration Formats
=========================================

As rsyslog has progressed, it now endorses two main configuration formats. These formats are designed to cater to a range of logging requirements, from simple to complex.

Advanced Format (Formerly RainerScript Format)
----------------------------------------------

*Preferred for Modern Use*
   The advanced format, introduced in rsyslog v6, is the recommended choice for all levels of complexity in modern logging scenarios.

*Performance and Flexibility*
   Originally perceived as performance-heavy, the advanced format has evolved to be efficient and versatile in the latest rsyslog versions.

*Ideal for Complex Tasks*
   Especially suited for intricate configurations, like handling logs with intermittently available remote hosts.

**Example**::

    mail.err action(type="omfwd" protocol="tcp" queue.type="linkedList")

*Advantages*

- Offers nuanced control through detailed parameters.
- Uses a clear block structure, enhancing readability and manageability.
- Perfectly suited for configurations that include multiple files.

*Recommendation*
   Opt for the advanced format in all new projects. Its comprehensive features and straightforward design make it the superior choice for any logging requirement.

Basic Format (Previously Sysklogd Format)
-----------------------------------------

*Simplicity with Limitations*
   The basic format is simple but limited in scope and flexibility. It's derived from the traditional syslog.conf format and is familiar in the industry.

*Not Recommended for New Users*
   Though basic, this format can appear cryptic and is often misunderstood by those new to syslog logging.

**Example**::

    mail.info /var/log/mail.log
    mail.err @@server.example.net

*Guidance*
   Use the basic format only if you are comfortable with its limitations and simplicity. For new projects and users, the advanced format is strongly advised.

Obsolete Legacy Format
-----------------------

*Not Recommended*
   This format is outdated and generally discouraged for any new configurations.

*Legacy Support*
   Its existence in rsyslog is to support older setups.

*Transition Advice*
   Users are encouraged to migrate to the advanced format for a more efficient and clearer configuration experience.

Selecting the Appropriate Format
================================

1. **Advanced Format**: The top recommendation for all new and existing projects. It's robust, user-friendly, and adaptable to a wide range of logging scenarios.

2. **Basic Format**: Consider using only if you have existing setups that utilize it, and you prefer its simplicity.

3. **Avoid Obsolete Legacy Format**: To ensure efficiency and modern standards in your logging setup, refrain from using the obsolete legacy format.

By aligning your configuration with the advanced format, you can fully leverage the capabilities of rsyslog, ensuring a more efficient, clear, and future-proof logging solution.



OLD
===

Rsyslog has evolved over several decades. For this reason it supports three
different configuration formats ("languages"):

-  |FmtBasicName| - previously known as the :doc:`sysklogd  <sysklogd_format>`
   format, this is the format best used to express basic things, such as where
   the statement fits on a single line. It stems back to the original
   syslog.conf format, in use now for several decades.

   The most common use case is matching on facility/severity and writing
   matching messages to a log file.

-  |FmtAdvancedName| - previously known as the ``RainerScript`` format, this
   format was first available in rsyslog v6 and is the current, best and most
   precise format for non-trivial use cases where more than one line is needed.

   Prior to v7, there was a performance impact when using this format that
   encouraged use of the |FmtBasicName| format for best results. Current
   versions of rsyslog do not suffer from this (historical) performance impact.

   This new style format is specifically targeted towards more advanced use
   cases like forwarding to remote hosts that might be partially offline.

-  |FmtObsoleteName| - previously known simply as the ``legacy`` format, this
   format is exactly what its name implies: it is obsolete and should not
   be used when writing new configurations. It was created in the early
   days (up to rsyslog version 5) where we expected that rsyslog would extend
   sysklogd just mildly.  Consequently, it was primarily aimed at small
   additions to the original sysklogd format. Practice has shown that it
   was notoriously hard to use for more advanced use cases, and thus we
   replaced it with the |FmtAdvancedName| format.

   In essence, everything that needs to be written on a single line that
   starts with a dollar sign is legacy format. Users of this format are
   encouraged to migrate to the |FmtBasicName| or |FmtAdvancedName| formats.

Which Format should I Use?
~~~~~~~~~~~~~~~~~~~~~~~~~~

While rsyslog supports all three formats concurrently, you are **strongly**
encouraged to avoid using the |FmtObsoleteName| format. Instead, you should
use the |FmtBasicName| format for basic configurations and the |FmtAdvancedName|
format for anything else.

While it is an older format, the |FmtBasicName| format is still suggested for
configurations that mostly consist of simple statements. The classic
example is writing to files (or forwarding) via priority. In |FmtBasicName|
format, this looks like:

::

   mail.info /var/log/mail.log
   mail.err @@server.example.net

This is hard to beat in simplicity, still being taught in courses
and a lot of people know this syntax. It is perfectly fine to use
these constructs even in newly written config files. Note that many
distributions use this format in their default rsyslog.conf, so you will
likely find it in existing configurations.

**For anything more advanced, use** the |FmtAdvancedName| format. Advantages are:

- fine control over rsyslog operations via advanced parameters
- easy to follow block structure
- easy to write
- safe for use with include files

To continue with the above example, the |FmtAdvancedName| format is preferable
if you want to make sure that an offline remote destination will not slow down
local log file writing. In that case, forwarding is done via:

::

   mail.err action(type="omfwd" protocol="tcp" queue.type="linkedList")

As can be seen by this example, the |FmtAdvancedName| format permits specifying
additional parameters to fine tune the behavior, whereas the |FmtBasicName|
format does not provide this level of control.

**Do not use** |FmtObsoleteName| **format. It will make your life
miserable.** It is primarily supported in order to not break existing
configurations.

Whatever you can do with the |FmtObsoleteName| format, you can also do
with the |FmtAdvancedName| format. The opposite is not true: Many newer features
cannot be turned on via the |FmtObsoleteName| format. The |FmtObsoleteName|
format is hard to understand and hard to get right. As you may inherit a rsyslog
configuration that makes use of it, this documentation gives you some clues
of what the obsolete statements do. For full details, obtain a
`v5 version of the rsyslog
documentation <http://www.rsyslog.com/doc/v5-stable/index.html>`_ (yes, this
format is dead since 2010!).
