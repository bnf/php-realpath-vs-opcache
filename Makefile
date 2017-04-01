.PHONY: check setup shutdown

.travis/assert-1.1.sh:
	wget https://raw.github.com/lehmannro/assert.sh/v1.1/assert.sh -O $@
	ln -snf assert-1.1.sh .travis/assert.sh

.travis/cachetool.phar:
	wget http://gordalina.github.io/cachetool/downloads/cachetool.phar -O $@
	chmod +x $@

prepare: .travis/assert-1.1.sh .travis/cachetool.phar

setup:
	@$(MAKE) shutdown
	.travis/install-nginx.sh

check: prepare setup
	HOST=http://localhost:8088 .travis/run-tests.sh
	#@$(MAKE) shutdown

shutdown:
	-pkill -F /tmp/php-fpm.pid
	-pkill -F /tmp/nginx.pid
	-rm -rf .travis/nginx/
