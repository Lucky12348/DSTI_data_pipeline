<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (XML): Summary of tours and events.
  - Produce a compact XML grouping tour, region, events with booking counts.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:key name="kBookingsByEvent" match="Operator/Bookings/Booking" use="EventRef"/>

    <xsl:template match="/">
        <ToursSummary>
            <xsl:apply-templates select="Operator/Regions/Region/Tours/Tour"/>
        </ToursSummary>
    </xsl:template>

    <xsl:template match="Tour">
        <TourSummary id="{@id}">
            <Title><xsl:value-of select="Title"/></Title>
            <Region><xsl:value-of select="ancestor::Region[1]/Name"/></Region>
            <Country><xsl:value-of select="ancestor::Region[1]/Country"/></Country>
            <DurationDays><xsl:value-of select="DurationDays"/></DurationDays>
            <Difficulty><xsl:value-of select="Difficulty"/></Difficulty>
            <BasePrice currency="{BasePrice/@currency}"><xsl:value-of select="BasePrice"/></BasePrice>
            <xsl:apply-templates select="TourEvents/TourEvent"/>
        </TourSummary>
    </xsl:template>

    <xsl:template match="TourEvent">
        <Event id="{@id}">
            <StartDate><xsl:value-of select="StartDate"/></StartDate>
            <EndDate><xsl:value-of select="EndDate"/></EndDate>
            <MaxParticipants><xsl:value-of select="MaxParticipants"/></MaxParticipants>
            <BookingCount><xsl:value-of select="count(key('kBookingsByEvent', @id))"/></BookingCount>
        </Event>
    </xsl:template>

</xsl:stylesheet>
