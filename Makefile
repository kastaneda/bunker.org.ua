ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
HTMLPROOFER := docker run --rm -v $(ROOT)_site:/_site 18fgsa/html-proofer

build: clean
	jekyll build

draft: clean
	jekyll build -D

compress:
	find _site -regex '.*\.\(html\|xml\|ico\)$$' | xargs zopfli --i50
	find _site -regex '.*\.\(html\|xml\|ico\)$$' | xargs brotli -Z

package: bunker.org.ua.tar.gz

bunker.org.ua.tar.gz:
	tar zcf $@ -C _site/ .

clean:
	rm -f bunker.org.ua.tar.gz

test:
	$(HTMLPROOFER) _site --check-html --check-opengraph --check-sri

post_clone:
	git ls-files | xargs  -I '{}' git log -1 --pretty=format:"%cI {} %n" {} | xargs -n2 touch -d

save_mtime:
	for f in `git diff --name-only | grep \.md$$`; do \
	  d=`date "+%F %X %z" -r $$f`; \
	  sed "s/^mtime:.*$$/mtime: $$d/" -i $$f; \
	  touch -d "$$d" $$f; \
	done

.PHONY: build draft compress package clean test post_clone save_mtime
