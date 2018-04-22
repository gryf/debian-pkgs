Package builder for Debian
==========================

Aim of this bunch of scripts is an automation for building couple of
applications which are missing in stable Debian system.

Applications covered by this project:

- `bubblemon`_ a Window Maker system monitor
- `wmamixer`_ a Window Maker ALSA mixer
- `xlockmore`_ small xlock descendant
- `peksystray` clean looking tray, which can be used with Window Maker

Usage
-----

Simply run ``./build.sh`` to build all the deb packages. Every script can be run
individually, but on top of this directory, for example::

    recipies/xlockmore.sh

Requirements
------------

First of all you'll need ``build-essential`` package and ``git`` for cloning
repos. All specific dependencies for a package are included in the recipe
script.

License
-------

This software is licensed under 3-clause BSD license. See LICENSE file for
details.

.. _bubblemon: http://www.ne.jp/asahi/linux/timecop/
.. _wmamixer: https://github.com/gryf/wmamixer
.. _xlockmore: http://www.sillycycle.com/xlockmore.html
.. _peksystray: http://peksystray.sourceforge.net
