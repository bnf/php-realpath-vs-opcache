Realpath symlink cache vs fpm opcache symlink entry point cache
===============================================================

[![Build Status](https://travis-ci.org/bnf/php-realpath-vs-opcache.svg?branch=master)](https://travis-ci.org/bnf/php-realpath-vs-opcache)

This repository demonstrates that common assumptions about php realpath()
are not (always) valid.

Background
----------

The php realpath() function seems to use another cache
than the php-fpm opcache path resolver.
The tests in this repository therefore show that realpaths may be
renewed while old scripts are still executed (that means: `realpath($_SERVER['DOCUMENT_ROOT']) != __DIR__`).
See .travis/run-tests.sh for the detailed tests.

Possible workaround is to never use `realpath()`, but always
rely on `__DIR__`/`__FILENAME__`.
That's demonstrated in: https://github.com/bnf/static-docroot
which is tested with TYPO3 7 LTS and TYPO3 8.6 to provide stable
`DOCUMENT_ROOT` and `SCRIPT_FILENAME` values.


How to use
----------

```
# on fedora
dnf install nginx coreutils php-fpm

# on debian/ubuntu
apt-get install nginx-extras realpath php-fpm

```

```
make check

make shutdown
```


Futher readings
---------------

https://codeascraft.com/2013/07/01/atomic-deploys-at-etsy/

https://github.com/zendtech/ZendOptimizerPlus/issues/126#issuecomment-210537841

https://github.com/zendtech/ZendOptimizerPlus/issues/126#issuecomment-221038140
