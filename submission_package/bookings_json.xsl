<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (JSON): Enriched bookings list (client, tour, region, dates, total paid).
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:key name="kClient" match="Operator/Clients/Client" use="@id"/>
    <xsl:key name="kEvent" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent" use="@id"/>

    <xsl:template match="/">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="Operator/Bookings/Booking">
            <xsl:sort select="BookingDate"/>
        </xsl:apply-templates>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="Booking">
        <xsl:if test="position() &gt; 1"><xsl:text>,</xsl:text></xsl:if>
        <xsl:variable name="client" select="key('kClient', ClientRef)"/>
        <xsl:variable name="event" select="key('kEvent', EventRef)"/>
        <xsl:variable name="tour" select="$event/ancestor::Tour[1]"/>
        <xsl:variable name="region" select="$tour/ancestor::Region[1]"/>
        <xsl:variable name="total" select="sum(Payments/Payment/Amount)"/>
        <xsl:text>{</xsl:text>
        <xsl:text>"id":"</xsl:text><xsl:value-of select="@id"/><xsl:text>",</xsl:text>
        <xsl:text>"bookingDate":"</xsl:text><xsl:value-of select="BookingDate"/><xsl:text>",</xsl:text>
        <xsl:text>"client":{"id":"</xsl:text><xsl:value-of select="$client/@id"/><xsl:text>","firstName":"</xsl:text><xsl:value-of select="$client/FirstName"/><xsl:text>","lastName":"</xsl:text><xsl:value-of select="$client/LastName"/><xsl:text>"},</xsl:text>
        <xsl:text>"tour":{"id":"</xsl:text><xsl:value-of select="$tour/@id"/><xsl:text>","title":"</xsl:text><xsl:value-of select="$tour/Title"/><xsl:text>","region":"</xsl:text><xsl:value-of select="$region/Name"/><xsl:text>"},</xsl:text>
        <xsl:text>"event":{"id":"</xsl:text><xsl:value-of select="$event/@id"/><xsl:text>","start":"</xsl:text><xsl:value-of select="$event/StartDate"/><xsl:text>","end":"</xsl:text><xsl:value-of select="$event/EndDate"/><xsl:text>"},</xsl:text>
        <xsl:text>"payments":{"count":</xsl:text><xsl:value-of select="count(Payments/Payment)"/><xsl:text>,"total":</xsl:text><xsl:value-of select="format-number($total, '0.00')"/><xsl:text>,"currency":"</xsl:text><xsl:value-of select="Payments/Payment[1]/Amount/@currency"/><xsl:text>"}</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>

</xsl:stylesheet>
