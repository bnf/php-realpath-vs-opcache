#!/bin/bash

DIR=$(realpath $(dirname "$0"))
ROOT=$(realpath "$DIR/..")

source $DIR/assert.sh


function test() {
	url=$1
	descriptive_name_unused=$2

	content=$(curl $args -s "${HOST}${url}" )
	echo $content
}

ln -snf release-1 $ROOT/web
assert "test / initial-state" "release-1: __DIR__:$ROOT/release-1 realpath:$ROOT/release-1"


ln -snf release-2 $ROOT/web
# Resetting opcache flushing both the opcache and the realpath cache, al fine
$DIR/cachetool.phar opcache:reset --fcgi 127.0.0.1:9876
assert "test / load-after-opcache" "release-2: __DIR__:$ROOT/release-2 realpath:$ROOT/release-2"


## THIS TEST WILL FAIL! the php realpath cache is reset, but the opcache not
ln -snf release-1 $ROOT/web
$DIR/cachetool.phar stat:clear --fcgi 127.0.0.1:9876
assert "test / realpath-is-newer-than-php-opcache" "release-2: __DIR__:$ROOT/release-2 realpath:$ROOT/release-1"


assert_end symlink