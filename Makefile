build:
	jekyll build
	find _site -regex '.*\.\(html\|xml\|txt\|ico\)$$' | xargs gzip -k9
	tar zcf bunker.org.ua.tar.gz -C _site/ .

.PHONY: build
