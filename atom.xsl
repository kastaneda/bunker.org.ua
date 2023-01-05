---
layout: none
---

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="atom">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
<xsl:template match="/">
<!-- xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="">
  <xsl:attribute name="lang">
    <xsl:value-of select="/atom:feed/@xml:lang"/>
  </xsl:attribute>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><xsl:value-of select="/atom:feed/atom:title"/></title>
    <style>
{{ '@import "main"' | sassify | remove_first: '@charset "UTF-8";' | replace: '

', '
'}}    </style>
  </head>
  <body>
    <h1><xsl:value-of select="/atom:feed/atom:title"/></h1>
    <p><xsl:value-of select="/atom:feed/atom:subtitle"/></p>
    <xsl:for-each select="/atom:feed/atom:entry">
      <article itemscope="" itemtype="http://schema.org/Article">
        <h2>
          <a href="">
            <xsl:attribute name="href">
              <xsl:value-of select="atom:link/@href"/>
            </xsl:attribute>
            <xsl:value-of select="atom:title"/>
          </a>
        </h2>
        <p>
          <time itemprop="datePublished" datetime="">
            <xsl:attribute name="datetime">
              <xsl:value-of select="atom:updated"/>
            </xsl:attribute>
            <xsl:value-of select="substring(atom:updated,0,11)"/>
          </time>
        </p>
        <xsl:copy-of select="atom:content/*"/>
      </article>
    </xsl:for-each>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
