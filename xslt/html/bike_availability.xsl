<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (HTML): Bike availability by region.
  - List each bike with its current status.
  - Compute how many bookings reference the bike (Bookings/BookedBike/@ref).
  - Highlight reserved/in-maintenance bikes vs available ones.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Keys -->
    <xsl:key name="kBookingsByBike" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent/EventBookings/Booking/BookedBikes/BookedBike" use="@ref"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Bike availability</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    .region { background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); padding: 16px; margin-bottom: 20px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    th { background: #0f172a; color: #fff; padding: 8px; text-align: left; }
                    td { padding: 8px; border-bottom: 1px solid #e5e7eb; }
                    .status { padding: 4px 10px; border-radius: 12px; color: #fff; font-size: 0.85em; }
                    .Available { background: #16a34a; }
                    .Reserved { background: #f59e0b; }
                    .InMaintenance { background: #dc2626; }
                </style>
            </head>
            <body>
                <h1>Bike availability</h1>
                <xsl:apply-templates select="Operator/Regions/Region"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Region">
        <div class="region">
            <h2><xsl:value-of select="Name"/> (<xsl:value-of select="Country"/>)</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Type</th>
                        <th>Price/day</th>
                        <th>Status</th>
                        <th>Bookings</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="Bikes/Bike"/>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="Bike">
        <xsl:variable name="bookingCount" select="count(key('kBookingsByBike', @id))"/>
        <tr>
            <td><xsl:value-of select="@id"/></td>
            <td><xsl:value-of select="Brand"/></td>
            <td><xsl:value-of select="Model"/></td>
            <td><xsl:value-of select="Type"/></td>
            <td><xsl:value-of select="DailyPrice"/> <xsl:value-of select="DailyPrice/@currency"/></td>
            <td><span class="status {Status}"><xsl:value-of select="Status"/></span></td>
            <td><xsl:value-of select="$bookingCount"/> booking(s)</td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
