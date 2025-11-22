<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (XML): Bike inventory by region.
  - Emit an XML structure listing bikes with status and booking count.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:key name="kBookingsByBike" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent/EventBookings/Booking/BookedBikes/BookedBike" use="@ref"/>

    <xsl:template match="/">
        <BikeInventory>
            <xsl:apply-templates select="Operator/Regions/Region"/>
        </BikeInventory>
    </xsl:template>

    <xsl:template match="Region">
        <RegionBikes id="{@id}">
            <Name><xsl:value-of select="Name"/></Name>
            <Country><xsl:value-of select="Country"/></Country>
            <xsl:apply-templates select="Bikes/Bike"/>
        </RegionBikes>
    </xsl:template>

    <xsl:template match="Bike">
        <Bike id="{@id}">
            <Brand><xsl:value-of select="Brand"/></Brand>
            <Model><xsl:value-of select="Model"/></Model>
            <Type><xsl:value-of select="Type"/></Type>
            <Status><xsl:value-of select="Status"/></Status>
            <DailyPrice currency="{DailyPrice/@currency}"><xsl:value-of select="DailyPrice"/></DailyPrice>
            <BookingCount><xsl:value-of select="count(key('kBookingsByBike', @id))"/></BookingCount>
        </Bike>
    </xsl:template>

</xsl:stylesheet>
