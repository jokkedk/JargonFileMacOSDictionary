<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng"
                version="1.0">

<xsl:template match="/book">
<d:dictionary xmlns="http://www.w3.org/1999/xhtml" xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng">
    <d:entry id="front_back_matter" d:title="Front/Back Matter">
        <h1>Jargon File for MacOS</h1>
        <p>This is the Jargon File converted to Apple Dictionary format by <a href="http://jokke.dk">Joakim Nygård</a>.
        There might be formatting problems and missing content compared to the source material maintained by <a href="http://www.catb.org/~esr/jargon/">Eric Raymond</a>. Use at your own discretion.</p>

        <h2>Table of Contents</h2>
        <ol type="I">
            <li><p>Introduction</p>
            <ol type="1">
            <xsl:for-each select="part/chapter">
                <li><p>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>x-dictionary:r:</xsl:text>
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </p></li>
            </xsl:for-each>
            </ol></li>

            <li><p>Appendices</p>
            <ol type="A">
            <xsl:for-each select="part/appendix">
                <xsl:if test="@id">
                <li><p>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>x-dictionary:r:</xsl:text>
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                    </a>
                </p></li>
                </xsl:if>
            </xsl:for-each>
            </ol></li>

            <li><p><a href="x-dictionary:r:bibliography">Bibliography</a></p></li>
        </ol>
    </d:entry>
    <xsl:apply-templates select="part/chapter"/>
    <xsl:apply-templates select="part/glossary/glossdiv/glossentry"/>
    <xsl:apply-templates select="part/appendix"/>
    <xsl:apply-templates select="part/bibliography"/>
</d:dictionary>
</xsl:template>

<xsl:template match="chapter|appendix">
    <xsl:if test="@id">
    <d:entry id="{@id}">
        <xsl:attribute name="d:title"><xsl:value-of select="title"/></xsl:attribute>
        <h1><xsl:value-of select="title"/></h1>
        <xsl:for-each select="*">
        <xsl:choose>
            <xsl:when test="name(.)='table'">
                <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:when test="name(.)='mediaobject'">
                <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:when test="name(.)='title'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="."/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
    </d:entry>
    </xsl:if>
</xsl:template>

<xsl:template match="bibliography">
    <d:entry id="bibliography" d:title="bibliography">
        <h1>Bibliography</h1>
        <ul>
        <xsl:for-each select="biblioentry">
        <li>
            <xsl:if test="authorgroup">
            <xsl:for-each select="authorgroup/author">
            <xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:value-of select="surname"/>,
            </xsl:for-each>
            </xsl:if>
            <xsl:value-of select="author/firstname"/><xsl:text> </xsl:text><xsl:value-of select="author/surname"/>:
            <cite><xsl:value-of select="title"/></cite>,
            <xsl:value-of select="publisher/publishername"/>,
            <xsl:value-of select="copyright/year"/>,
            <xsl:value-of select="isbn"/>
            <xsl:apply-templates select="abstract" />
        </li>
        </xsl:for-each>
        </ul>
    </d:entry>
</xsl:template>

<xsl:template match="part">
    <d:entry id="{@id}"></d:entry>
    <xsl:apply-templates select="glossary/glossdiv/glossentry"/>
</xsl:template>

<xsl:template match="glossentry">
    <d:entry id="{@id}">
        <xsl:attribute name="d:title"><xsl:value-of select="glossterm"/></xsl:attribute>
        <xsl:if test="contains(glossterm, ' ')">
        <d:index>
            <xsl:attribute name="d:title"><xsl:value-of select="glossterm"/></xsl:attribute>
            <xsl:attribute name="d:value"><xsl:value-of select="glossterm"/></xsl:attribute>
        </d:index>
        </xsl:if>
        <xsl:call-template name="tokenize">
			<xsl:with-param name="text" select="glossterm"/>
			<xsl:with-param name="full" select="glossterm"/>
		</xsl:call-template>
        <div>
            <h1><xsl:value-of select="glossterm"/></h1>
            <xsl:apply-templates select="abbrev" />
            <xsl:apply-templates select="glossdef" />
        </div>
    </d:entry>
</xsl:template>

<xsl:template match="glossdef">
    <xsl:for-each select="*">
    <xsl:choose>
        <xsl:when test="name(.)='informaltable'">
            <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:when test="name(.)='mediaobject'">
            <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="."/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:for-each>
</xsl:template>

<xsl:template match="informaltable|table">
    <table>
    <xsl:if test="title"><caption><xsl:value-of select="title"/></caption></xsl:if>
    <xsl:for-each select="tgroup/*">
    <xsl:if test="name(.)='thead'">
    <thead>
    <xsl:for-each select="row">
        <tr>
        <xsl:for-each select="entry">
            <th><xsl:apply-templates select="."/></th>
        </xsl:for-each>
        </tr>
    </xsl:for-each>
    </thead>
    </xsl:if>
    <xsl:if test="name(.)='tbody'">
    <tbody>
    <xsl:for-each select="row">
        <tr>
        <xsl:for-each select="entry">
            <td><xsl:apply-templates select="."/></td>
        </xsl:for-each>
        </tr>
    </xsl:for-each>
    </tbody>
    </xsl:if>
    </xsl:for-each>
    </table>
</xsl:template>

<xsl:template match="para">
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="blockquote">
    <blockquote><xsl:apply-templates/></blockquote>
</xsl:template>

<xsl:template match="literallayout">
    <p class="whitespace"><xsl:apply-templates/></p>
</xsl:template>
<xsl:template match="screen">
    <pre><xsl:apply-templates/></pre>
</xsl:template>


<xsl:template match="//glossterm">
    <a>
        <xsl:attribute name="href">
            <xsl:text>x-dictionary:d:</xsl:text>
            <xsl:value-of select="."/>
        </xsl:attribute>
        <xsl:value-of select="."/>
    </a>
</xsl:template>

<xsl:template match="//sect1">
    <xsl:for-each select="*">
        <xsl:choose>
            <xsl:when test="name(.)='title'">
                <h2><xsl:value-of select="."/></h2>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>

<xsl:template match="//sect2">
    <h3><xsl:value-of select="title"/></h3>
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="ulink">
    <a href="{@url}"><xsl:value-of select="."/></a>
</xsl:template>

<xsl:template match="mediaobject">
    <figure>
    <xsl:for-each select="*">
        <xsl:if test="name(.)='imageobject'">
            <img><xsl:attribute name="src"><xsl:value-of select="imagedata/@fileref"/></xsl:attribute></img>
        </xsl:if>
        <xsl:if test="name(.)='caption'">
        <figcaption><xsl:value-of select="para"/></figcaption>
        </xsl:if>
    </xsl:for-each>
    </figure>
</xsl:template>

<!-- <xsl:template match="revhistory">
</xsl:template> -->
<xsl:template match="abbrev">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="systemitem|command|literal">
    <code><xsl:value-of select="."/></code>
</xsl:template>

<xsl:template match="citetitle">
    <cite><xsl:value-of select="."/></cite>
</xsl:template>

<xsl:template match="itemizedlist">
    <ul>
        <xsl:for-each select="listitem">
        <li><xsl:apply-templates /></li>
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template match="quote">“<xsl:value-of select="."/>”</xsl:template>

<xsl:template match="emphasis">
    <xsl:choose>
    <xsl:when test="@role='pronunciation'">
        <span class="syntax"><span d:pr="1">| <xsl:value-of select="."/> |</span></span>
    </xsl:when>
    <xsl:when test="@role='grammar'"></xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="."/>
    </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="tokenize">
    <xsl:param name="text"/>
    <xsl:param name="full"/>
    <xsl:param name="delimiter" select="' '"/>
    <xsl:choose>
        <xsl:when test="contains($text, $delimiter)">
            <d:index>
                <xsl:attribute name="d:title"><xsl:value-of select="$full"/></xsl:attribute>
                <xsl:attribute name="d:value"><xsl:value-of select="substring-before($text, $delimiter)"/></xsl:attribute>
            </d:index>
            <!-- recursive call -->
            <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="substring-after($text, $delimiter)"/>
                <xsl:with-param name="full" select="$full"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <d:index>
                <xsl:attribute name="d:title"><xsl:value-of select="$full"/></xsl:attribute>
                <xsl:attribute name="d:value"><xsl:value-of select="$text"/></xsl:attribute>
            </d:index>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
