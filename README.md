bunker.org.ua
=============

Jekyll-powered static site [bunker.org.ua](https://bunker.org.ua/).


Features
--------

 - Clean and simple minimalistic design
    - Dark mode supported
 - Lightweight and fast
 - Every page have English, Ukrainian, and Russian translations


Work in progress
----------------

Set each file timestamp to the time of the last commit:

```sh
for f in `git ls-files`; do d=`git log -1 --pretty=format:%cI $f`; touch -d $d $f; done
```

Update `mtime` field in front matter, based on file mtime:

```sh
for f in `find . -type f -name '*.md' | grep -v README`; do d=`date "+%F %X %z" -r $f`; sed "s/^mtime:.*$/mtime: $d/" -i $f; touch -d "$d" $f; done
```
