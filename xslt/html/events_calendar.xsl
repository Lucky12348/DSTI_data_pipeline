<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (HTML): Event calendar (departures).
  - List all TourEvent with Tour/Region, dates, max capacity, & booking count.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Event calendar</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); overflow: hidden; }
                    th { background: #0f172a; color: #fff; padding: 10px; text-align: left; }
                    td { padding: 10px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
                    .muted { color: #6b7280; }
                </style>
            </head>
            <body>
                <h1>Event calendar</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Dates</th>
                            <th>Tour</th>
                            <th>Region</th>
                            <th>Capacity</th>
                            <th>Bookings</th>
                        </tr>
                    </thead>
                <tbody>
                    <xsl:apply-templates select="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent">
                        <xsl:sort select="StartDate"/>
                    </xsl:apply-templates>
                </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="TourEvent">
        <xsl:variable name="bookings" select="EventBookings/Booking"/>
        <xsl:variable name="tour" select="ancestor::Tour[1]"/>
        <xsl:variable name="region" select="ancestor::Region[1]"/>
        <tr>
            <td><xsl:value-of select="StartDate"/> → <xsl:value-of select="EndDate"/></td>
            <td>
                <strong><xsl:value-of select="$tour/Title"/></strong><br/>
                <span class="muted"><xsl:value-of select="$tour/Difficulty"/></span>
            </td>
            <td><xsl:value-of select="$region/Name"/> (<xsl:value-of select="$region/Country"/>)</td>
            <td><xsl:value-of select="MaxParticipants"/></td>
            <td><xsl:value-of select="count($bookings)"/> booking(s)</td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
