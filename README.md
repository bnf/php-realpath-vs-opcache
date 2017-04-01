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
fresher than `__DIR__`.
See .travis/run-tests.sh.

Possible workaround is to never use realpath(), but always
rely on `__DIR__`/`__FILENAME__`.
That's demonstrated in: https://github.com/bnf/static-docroot


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
