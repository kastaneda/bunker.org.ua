# To install the build environment:
# apt install make jekyll imagemagick librsvg2-bin optipng advancecomp

ROOT := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

-include .env

JEKYLL ?= jekyll
HTMLPROOFER ?= htmlproofer

# To run dockerized version of build tools, '.env' file should be like:
#
# JEKYLL = docker run --rm -v $(ROOT):/srv/jekyll jekyll/jekyll jekyll
# HTMLPROOFER = docker run --rm -v $(ROOT):/src klakegg/html-proofer

DOMAIN := bunker.org.ua
TEXTFILES := '.*\.\(html\|css\|js\|txt\|xml\|ico\)$$'

all: build test

build:
	$(JEKYLL) build

up:
	$(JEKYLL) build --drafts --watch

test: test-local

test-local: build
	$(HTMLPROOFER) ./_site \
		--disable-external \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https

test-external: build
	$(HTMLPROOFER) ./_site \
		--internal-domains https://$(DOMAIN) \
		--check-html \
		--check-favicon \
		--check-opengraph \
		--report-missing-names \
		--report-missing-doctype \
		--report-invalid-tags \
		--report-eof-tags \
		--report-mismatched-tags \
		--check-sri \
		--enforce_https \
		--only-4xx

clean:
	rm -fv $(ASSETS)
	rm -frv _site/
	rm -fv $(DOMAIN).tar.gz

compress:
	find _site -regex $(TEXTFILES) | xargs zopfli --i20
	find _site -regex $(TEXTFILES) | xargs brotli -fZ

package: build compress $(DOMAIN).tar.gz

$(DOMAIN).tar.gz:
	tar zcf $@ -C _site/ .

post_clone:
	git ls-files | xargs  -I '{}' git log -1 --pretty=format:"%cI {} %n" {} | xargs -n2 touch -d

save_mtime:
	for f in `git diff --name-only | grep \.md$$`; do \
	  d=`date "+%F %X %z" -r $$f`; \
	  sed "s/^mtime:.*$$/mtime: $$d/" -i $$f; \
	  touch -d "$$d" $$f; \
	done

.PHONY: all build up test test-local test-external clean compress package $(DOMAIN).tar.gz post_clone save_mtime
