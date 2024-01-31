<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
<!-- This template processes the root node ("/") -->
<xsl:template match="/">
    <coverage>
        <xsl:attribute name='generated'>
            <xsl:value-of select='/coverage/@timestamp'/>
        </xsl:attribute>
        <project>
            <xsl:attribute name='timestamp'>
                <xsl:value-of select='/coverage/@timestamp'/>
            </xsl:attribute>
        <xsl:apply-templates
            select='//classes'/>
        <xsl:variable name='methods' select='count(current()//methods//line)'/>
        <xsl:variable name='ncloc' select='count(current()//line) - number($methods)'/>
        <xsl:call-template name='metrics'>
            <xsl:with-param name='ncloc'
                select="$ncloc"
                />
            <xsl:with-param name='files'
                select="count(current()//class)"
                />
            <xsl:with-param name='elements'
                select='$ncloc'/>
            <xsl:with-param name='coveredelements'
                select='number($ncloc) + count(current()//methods//line[number(@hits) = 0]) - count(current()//line[number(@hits) = 0])'/>
            <xsl:with-param name='methods'
                select='$methods'/>
            <xsl:with-param name='coveredmethods'
                select='number($methods) - count(current()//methods//line[number(@hits) = 0])'/>
        </xsl:call-template>
        </project>
    </coverage>
</xsl:template>
<xsl:template match="class">
    <file>
        <xsl:attribute name='name'>
            <xsl:value-of select='current()/@filename'/>
        </xsl:attribute>
        <xsl:for-each select='lines/line'>
            <line type='stmt'>
                <xsl:attribute name='num'>
                    <xsl:value-of select='current()/@number'/>
                </xsl:attribute>
                <xsl:attribute name='count'>
                    <xsl:value-of select='current()/@hits'/>
                </xsl:attribute>
            </line>
        </xsl:for-each>
        <xsl:variable name='methods' select='count(current()//methods//line)'/>
        <xsl:variable name='ncloc' select='count(current()//line) - number($methods)'/>
        <xsl:call-template name='metrics'>
            <xsl:with-param name='ncloc'
                select="$ncloc"
                />
            <xsl:with-param name='files'
                select="1"
                />
            <xsl:with-param name='elements'
                select='$ncloc'/>
            <xsl:with-param name='coveredelements'
                select='number($ncloc) + count(current()//methods//line[number(@hits) = 0]) - count(current()//line[number(@hits) = 0])'/>
            <xsl:with-param name='methods'
                select='$methods'/>
            <xsl:with-param name='coveredmethods'
                select='number($methods) - count(current()//methods//line[number(@hits) = 0])'/>
        </xsl:call-template>
    </file>
</xsl:template>
<xsl:template name='metrics'>
    <xsl:param name='elements' select='number(0)'/>
    <xsl:param name='coveredelements' select='number(0)'/>
    <xsl:param name='files' select='number(0)'/>
    <xsl:param name='ncloc' select='number(0)'/>
    <xsl:param name='methods' select='number(0)'/>
    <xsl:param name='coveredmethods' select='number(0)'/>
    <metrics>
        <xsl:attribute name='ncloc'>
            <xsl:value-of select='$ncloc'/>
        </xsl:attribute>
        <xsl:if test='number(coveredelements) != 0'>
            <xsl:attribute name='coveredelements'>
                <xsl:value-of select='$coveredelements'/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test='number(elements) != 0'>
            <xsl:attribute name='elements'>
                <xsl:value-of select='$elements'/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test='number(files) != 0'>
            <xsl:attribute name='files'>
                <xsl:value-of select='$files'/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test='number(methods) != 0'>
            <xsl:attribute name='methods'>
                <xsl:value-of select='$methods'/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test='number(coveredmethods) != 0'>
            <xsl:attribute name='coveredmethods'>
                <xsl:value-of select='$coveredmethods'/>
            </xsl:attribute>
        </xsl:if>
    </metrics>
</xsl:template>
</xsl:stylesheet>
