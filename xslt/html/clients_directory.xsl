<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (HTML): Clients directory.
  - List all clients with contact details.
  - Show booking count and, for each booking, the linked tour/event.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Keys -->
    <xsl:key name="kBookingsByClient" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent/EventBookings/Booking" use="ClientRef"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Clients directory</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); padding: 16px; margin-bottom: 16px; }
                    .muted { color: #6b7280; }
                    .bookings { margin-top: 10px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 6px; }
                    th { background: #0f172a; color: #fff; padding: 8px; text-align: left; }
                    td { padding: 8px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
                </style>
            </head>
            <body>
                <h1>Clients directory</h1>
                <xsl:apply-templates select="Operator/Clients/Client">
                    <xsl:sort select="LastName"/>
                    <xsl:sort select="FirstName"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Client">
        <xsl:variable name="bookings" select="key('kBookingsByClient', @id)"/>
        <div class="card">
            <h2><xsl:value-of select="FirstName"/><xsl:text> </xsl:text><xsl:value-of select="LastName"/></h2>
            <div class="muted">
                <xsl:value-of select="Email"/> — <xsl:value-of select="Phone"/>
            </div>
            <div>
                <xsl:value-of select="Address/Street"/><xsl:text>, </xsl:text>
                <xsl:value-of select="Address/City"/><xsl:text> </xsl:text>
                <xsl:value-of select="Address/ZipCode"/><xsl:text>, </xsl:text>
                <xsl:value-of select="Address/Country"/>
            </div>
            <div class="muted">Birth date: <xsl:value-of select="BirthDate"/></div>

            <div class="bookings">
                <strong><xsl:value-of select="count($bookings)"/> booking(s)</strong>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Tour / Region</th>
                            <th>Payments</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:choose>
                            <xsl:when test="$bookings">
                                <xsl:for-each select="$bookings">
                                    <xsl:sort select="BookingDate"/>
                                    <xsl:variable name="event" select="ancestor::TourEvent[1]"/>
                                    <xsl:variable name="tour" select="$event/ancestor::Tour[1]"/>
                                    <xsl:variable name="region" select="$tour/ancestor::Region[1]"/>
                                    <tr>
                                        <td><xsl:value-of select="@id"/></td>
                                        <td><xsl:value-of select="BookingDate"/></td>
                                        <td>
                                            <xsl:value-of select="$tour/Title"/>
                                            <xsl:text> (</xsl:text><xsl:value-of select="$region/Name"/><xsl:text>)</xsl:text>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(Payments/Payment)"/> payment(s),
                                            total:
                                            <xsl:value-of select="format-number(sum(Payments/Payment/Amount), '0.00')"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="Payments/Payment[1]/Amount/@currency"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <tr><td colspan="4" class="muted">No bookings</td></tr>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
