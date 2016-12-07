.. _overview:

Overview
========

Rsyslog **The rocket-fast system for log processing** project started back in 
2004 to improve how `syslog <https://en.wikipedia.org/wiki/Syslog>`_ handled logs.

Time flied, and now it has become a swiss army tool to handle logs, being able
to get inputs from multiple sources, applying multiple transformations and 
enrichments over messages and sending them to another bunch of possible targets.

Too briefly, that's what rsyslog looks like:
 
.. graphviz::

   digraph overview {
     { rank=same; input->"Do whatever you want"->output; }
     blank [style=invis];
   }

As stated above, Rsyslog works with multiple `input modules <http://www.rsyslog.com/doc/master/configuration/modules/idx_input.html>`_
(prefixed with *im*) and `output modules <http://www.rsyslog.com/doc/master/configuration/modules/idx_output.html>`_
(prefixed *om*). It also supports a few `parser modules <http://www.rsyslog.com/doc/master/configuration/modules/idx_parser.html>`_ (prefixed with *pm*), `message modification modules <http://www.rsyslog.com/doc/master/configuration/modules/idx_messagemod.html>`_ (prefixed with *mm*), and other `cool stuff <http://www.rsyslog.com/doc/master/configuration/modules/index.html>`_. Don't worry, we'll review them later. To sum up, Rsyslog seems more like:

.. graphviz::

   digraph overview {
     { rank=same; "im*"->"pm*"->"mm*"->"om*"; }
     blank [style=invis];
   }

To better handle each message, rsyslog is built with `queues <http://www.rsyslog.com/doc/master/concepts/queues.html>`_ in mind: each message is queued on receive, processed by a *worker* thread and sent to target. It's also important 
to note that Rsyslog was built to process logs, and however it can handle any 
message, **it considers messages have format**. There's where parsers come into play.

When a message is received, before queueing, a parser tries to split messages into `well-known properties 
<http://www.rsyslog.com/doc/master/configuration/properties.html>`_ 
that aproximately match log format standards.

If messages follow `RFC3164 <https://tools.ietf.org/html/rfc3164>`_ or `RFC5424 <https://tools.ietf.org/html/rfc5424>`_ everything will work as expected. Otherwise, you'll have to struggle a bit with them.

After receiving each message, Rsyslog main thread push it to *main_queue* and one worker 
thread starts doing *the magic*. To do so, it interprets what written on the 
`config file <http://www.rsyslog.com/doc/master/configuration/basic_structure.html#configuration-file>`_.

At this point, this is more or less how Rsyslog should look to you:

.. graphviz::

   digraph parsers {
     { rank=same; "im*"->"pm*"->main_queue->"om*" }
     main_queue->"mm*"
     "mm*"->main_queue
     blank [style=invis];
   }

Apart from queues, Rsyslog is powered by `templates <http://www.rsyslog.com/doc/master/configuration/templates.html>`_ 
which can help formatting anything as string, completely modifying the resulting message, `rulesets <http://www.rsyslog.com/doc/master/concepts/multi_ruleset.html>`_ which let you dfine an specific-isolated processing pipeline and `actions <http://www.rsyslog.com/doc/master/configuration/actions.html>`_ which actually do the transformations.

For better understanding, here is an example:

.. code:: 

    ruleset(name="special_pipeline"){
      action(
        name="special"
        file="special.log"
        type="omfile"
      )
    }
    action(
      name="main"
      file="main_pipeline.log"
      type="omfile"
    )
    input(
      file="foo.log"
      ruleset="special_pipeline"
      type="imfile"
    )
    input(
      file="bar.log"
      type="imfile"
    )

As you can figure out:
  - Rsyslog is *listening* for two inputs (actually files).
  - *foo.log* input has a ruleset defined, so messages will be processed on a separate pipeline and messages from file will be written to *special.log* only.
  - *bar.log* is processed by main pipeline, hence messages will be written to *main_pipeline.log*.
  - Inputs use *im\** while action use *om\** (among others).

More or less, rsyslog process can be summarized as:

.. graphviz::

   digraph parsers {
     a1 [style=invis]
     a2 [style=invis]
     a5 [style=invis]
     b3 [style=invis]
     c1 [style=invis]
     c2 [style=invis]
     c5 [style=invis]
     { rank=same; a1->a2->main_pipeline [style=invis]; main_pipeline->main_queue; main_queue->a5 [style=invis] }
     { rank=same; "im*"->"pm*"; "pm*"->b3 [style=invis]; b3->"mm*" [style=invis]; "mm*"->"om*" [style=invis] }
     { rank=same; c1->c2->ruleset_pipeline[style=invis]; ruleset_pipeline->ruleset_queue; ruleset_queue->c5 [style=invis] }
     a1->"im*"->c1 [style=invis]
     a2->"pm*"->c2 [style=invis]
     main_pipeline->b3->ruleset_pipeline [style=invis]
     "mm*"->main_queue [style=dashed]
     main_queue->"mm*"->ruleset_queue [style=dashed]
     ruleset_queue->"mm*" [style=dashed]
     a5->"om*"->c5 [style=invis]
     "pm*"->main_pipeline
     "pm*"->ruleset_pipeline
     main_queue->"om*"
     ruleset_queue->"om*"
  }

Full documentation can be found at http://www.rsyslog.com/doc/master/configuration/index.html
