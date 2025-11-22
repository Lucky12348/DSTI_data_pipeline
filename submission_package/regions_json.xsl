<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (JSON): Region synthesis (counts of tours, events, routes, bikes).
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="Operator/Regions/Region">
            <xsl:sort select="Name"/>
        </xsl:apply-templates>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="Region">
        <xsl:if test="position() &gt; 1"><xsl:text>,</xsl:text></xsl:if>
        <xsl:text>{</xsl:text>
        <xsl:text>"id":"</xsl:text><xsl:value-of select="@id"/><xsl:text>",</xsl:text>
        <xsl:text>"name":"</xsl:text><xsl:value-of select="Name"/><xsl:text>",</xsl:text>
        <xsl:text>"country":"</xsl:text><xsl:value-of select="Country"/><xsl:text>",</xsl:text>
        <xsl:text>"routes":</xsl:text><xsl:value-of select="count(CyclingRoutes/CyclingRoute)"/><xsl:text>,</xsl:text>
        <xsl:text>"tours":</xsl:text><xsl:value-of select="count(Tours/Tour)"/><xsl:text>,</xsl:text>
        <xsl:text>"events":</xsl:text><xsl:value-of select="count(Tours/Tour/TourEvents/TourEvent)"/><xsl:text>,</xsl:text>
        <xsl:text>"bikes":</xsl:text><xsl:value-of select="count(Bikes/Bike)"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

</xsl:stylesheet>
