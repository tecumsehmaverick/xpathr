<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes" />

<xsl:param name="sha1" select="''" />
<xsl:param name="github-user" select="''" />
<xsl:param name="ui-assets" select="concat($workspace, '/assets/ui/')" />

<xsl:template match="/">
	<html lang="en">
		<head>
			<meta charset="utf-8" />
			<title>XPathr - Collaborative XSLT Development</title>
			<link rel="stylesheet" href="{$ui-assets}codemirror/lib/codemirror.css" />
			<link rel="stylesheet" href="{$ui-assets}codemirror/theme/default.css" />
			<link rel="stylesheet" href="{$ui-assets}css/xpathr.css" type="text/css" />
			<script src="{$ui-assets}codemirror/lib/codemirror.js"></script>
			<script src="{$ui-assets}codemirror/mode/xml/xml.js"></script>
		</head>
		<!--[if lt IE 7 ]><body class="source ie6"><![endif]--> 
		<!--[if !IE]><!--><body class="source"><!--<![endif]-->	 
			<div id="header">
				<h1><a href="{$root}/">XPathr</a></h1>
				<div class="help">
					<ul class="nav">
						<xsl:apply-templates select="data/events/github" />
						<li id="btn-about"><a href="#help">About</a></li>
					</ul>
				</div>
			</div>
			<xsl:apply-templates select="data" mode="xpathr" />
			<xsl:call-template name="help-panel" />
			<xsl:call-template name="codemirror" />
			<script src="{$ui-assets}js/jquery.min.js"></script>
			<script src="{$ui-assets}js/xpathr.js"></script>
		</body>
	</html>
</xsl:template>

<xsl:template match="data" mode="xpathr">
	<form id="main" method="post" action="">
		<xsl:call-template name="control" />
		<xsl:call-template name="bin" />
	</form>
</xsl:template>

<xsl:template name="control">
	<div id="control">
		<div class="control">
			<div class="buttons">
				<xsl:call-template name="buttons" />
			</div>
			<div class="actions">
				<xsl:call-template name="actions" />
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template name="buttons">
	<a class="tab button group left" accesskey="1" href="#xml" id="btn-xml">XML</a>
	<a class="tab button group gap right" accesskey="2" href="#xslt" id="btn-xslt">XSLT</a>
	<xsl:apply-templates select="params/gist-id" mode="process" />
</xsl:template>

<xsl:template match="params/gist-id" mode="process">
	<a class="tab button btn-result left right" accesskey="3" href="{$root}/process/{$gist-id}/" id="btn-result">Result</a>
</xsl:template>

<xsl:template name="actions" />

<xsl:template name="bin">
	<div id="bin" class="stretch">
		<div id="source" class="binview stretch">
			<xsl:call-template name="xml-editor" />
			<xsl:call-template name="xslt-editor" />
		</div>
	</div>
</xsl:template>

<xsl:template name="xml-editor">
	<div class="code stretch xml">
		<div class="label"><p><strong>XML</strong></p></div>
		<textarea id="xml" name="xml" cols="50" rows="20"><xsl:call-template name="xml" /></textarea>
	</div>
</xsl:template>

<xsl:template name="xml">
&lt;data&gt;
  &lt;hello&gt;paste your xml here&lt;/hello&gt;
&lt;/data&gt;
</xsl:template>

<xsl:template name="xslt-editor">
	<div class="code stretch xslt">
		<div class="label"><p><strong>XSLT</strong></p></div>
		<textarea id="xslt" name="xsl" cols="50" rows="20"><xsl:call-template name="xslt" /></textarea>
	</div>
</xsl:template>

<xsl:template name="xslt">
&lt;xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"&gt;

  &lt;xsl:output method="xml" indent="yes" /&gt;

  &lt;xsl:template match="/"&gt;
    &lt;hi&gt;
      &lt;xsl:value-of select="data/hello" /&gt;
    &lt;/hi&gt;
  &lt;/xsl:template&gt;

&lt;/xsl:stylesheet&gt;
</xsl:template>

<xsl:template match="events/github">
	<xsl:if test="@logged-in = 'yes'">
		<li>
			<xsl:if test="$current-page = 'new'">
				<xsl:attribute name="class">current</xsl:attribute>
			</xsl:if>
			<a href="{$root}/">New</a>
		</li>
		<li><a href="?github-oauth-action=logout">Logout</a></li>
	</xsl:if>

	<xsl:if test="@logged-in = 'no'">
		<li><a href="{$root}/authenticate">Login</a></li>
	</xsl:if>
</xsl:template>

<xsl:template name="help-panel">
	<div id="help">
		<div id="content">
			<xsl:call-template name="meta" />
			<h1>XPathr</h1>
			<p>XPathr is an open source collaborative XSLT debugging tool developed with <a href="http://symphony-cms.com/">Symphony</a>.</p>
			<p>If you want to get involved to help make XPathr better (or perhaps fix a bug you've found), please <a href="http://github.com/alpacaaa/xpathr">fork XPathr on github</a> and send a pull request.</p>
			<h2>Created by</h2>
			<ul>
				<li><a href="http://symphony-cms.com/get-involved/member/alpacaaa/">Marco Sampellegrini</a></li>
				<li><a href="http://symphony-cms.com/get-involved/member/bauhouse/">Stephen Bau</a></li>
			</ul>
		</div>
	</div>
</xsl:template>

<xsl:template name="meta">
	<xsl:if test="$github-user">
		<div id="meta">
			<div id="user">
				<a href="https://gist.github.com/{$github-user}">
					<img src="https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-140.png" />
					<span class="username"><xsl:value-of select="$github-user" /></span>
				</a>
			</div>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template name="codemirror">
	<script>
		var xml_editor = CodeMirror.fromTextArea(document.getElementById("xml"));
		var xslt_editor = CodeMirror.fromTextArea(document.getElementById("xslt"));
	</script>
</xsl:template>

</xsl:stylesheet>
