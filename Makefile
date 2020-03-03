ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
HTMLPROOFER := docker run --rm -v $(ROOT)_site:/_site 18fgsa/html-proofer

build:
	jekyll build
	find _site -regex '.*\.\(html\|xml\|txt\|ico\)$$' | xargs gzip -k9
	tar zcf bunker.org.ua.tar.gz -C _site/ .

test:
	$(HTMLPROOFER) _site --check-html --check-opengraph --check-sri

post_clone:
	git ls-files | xargs  -I '{}' git log -1 --pretty=format:"%cI {} %n" {} | xargs -n2 touch -d

.PHONY: build test post_clone
