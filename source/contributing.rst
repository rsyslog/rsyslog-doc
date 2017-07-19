.. index:: ! contributing 

Contributing
############

**If you want to contribute to Rsyslog code** (thank you!), start having a look at overview and learning some basic concepts before getting to work with issues or enhacements. Joining the `mail list <http://lists.adiscon.net/mailman/listinfo/rsyslog>`_ is also a good idea.

**If you want to contribute to Rsyslog documentation** (thank you!) you should also start having a look at overview and learning some basic concepts, and also you'll need to know how documentation is built.

As you may know Rsyslog documentation is done using `reStructuredText <http://docutils.sourceforge.net/rst.html>`_ and 
built with `Sphinx <http://sphinx-doc.org/contents.html>`_ to be published as HTML 
in `rsyslog.com <http://www.rsyslog.com/doc/master/>`_.

**These are the required steps to build the documentation**

1. Install required software:

    python, git
    
2. Download the pip installer from: https://raw.github.com/pypa/pip/master/contrib/get-pip.py
3. Run the pip installer

    Linux: python ./get-pip.py
    Windows: c:\\python27\\python get-pip.py
    
4. Install sphinx

    Linux: pip install sphinx 
    Windows: c:\\python27\\scripts\\pip install sphinx

5. Get *rsyslog-doc* code:

    git clone https://github.com/rsyslog/rsyslog-doc.git

6. Build html files

    Linux: sphinx-build -b html source build
    Windows: c:\\python27\\scripts\\sphinx-build -b html source build

7. Open rsyslog-doc/build/index.html in a browser

Some tips
=========

Import old missing content
**************************

For the time being, occasionally a page from older version branches seems to be missing in rsyslog-doc master. To recover it, you may check out the respective branch and run the following command to reverse-convert it to rst:

    $ pandoc -f html -t rst -o

Graphs
******

For graphs we are currently using `graphviz <http://www.webgraphviz.com/>`_.

To embed graphs into documentation we use `sphinx graphviz extension <http://www.sphinx-doc.org/en/master/ext/graphviz.html>`_.

As github doesnt render graphviz, you could use `gravizo <http://www.gravizo.com>`_ for testing and content review, but **it's not allowed to use it in pull requests.**
If you decide to use it, it needs to be `encoded <http://www.gravizo.com/#converter>`_. Decoding is possible to update an existing graph.
