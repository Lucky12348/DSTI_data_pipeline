<?xml version="1.0" encoding="UTF-8"?>
<!--
  XSLT Scenario: HTML catalogue of tours per region, with schedules, difficulty badges,
  and booking counts (bookings read from Operator/Bookings via EventRef).
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Keys for fast lookup -->
    <xsl:key name="kBookingsByEvent" match="Operator/Bookings/Booking" use="EventRef"/>
    <xsl:key name="kGuideById" match="Operator/Guides/Guide" use="@id"/>
    <xsl:key name="kRouteById" match="Operator/Regions/Region/CyclingRoutes/CyclingRoute" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Cycling Tours Catalog</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    .region-card { background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); padding: 20px; margin-bottom: 24px; }
                    .region-header { display: flex; justify-content: space-between; align-items: baseline; gap: 8px; }
                    .muted { color: #6b7280; font-size: 0.95em; }
                    .tour { border-top: 1px solid #e5e7eb; padding-top: 16px; margin-top: 16px; }
                    .tour:first-of-type { border-top: none; padding-top: 0; margin-top: 0; }
                    .title-line { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
                    .badge { padding: 4px 10px; border-radius: 12px; color: #fff; font-size: 0.85em; }
                    .Easy { background: #16a34a; }
                    .Moderate { background: #f59e0b; }
                    .Hard { background: #dc2626; }
                    .price { font-weight: 600; color: #0ea5e9; }
                    .events { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    .events th { background: #0f172a; color: #fff; padding: 8px; text-align: left; }
                    .events td { padding: 8px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
                    .taglist span { display: inline-block; margin: 2px 6px 2px 0; padding: 3px 8px; background: #e5e7eb; border-radius: 10px; font-size: 0.85em; }
                </style>
            </head>
            <body>
                <h1>Cycling Tours 2025</h1>
                <xsl:apply-templates select="Operator/Regions/Region"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Region">
        <div class="region-card">
            <div class="region-header">
                <h2><xsl:value-of select="Name"/> (<xsl:value-of select="Country"/>)</h2>
                <div class="muted">
                    <xsl:value-of select="count(Tours/Tour)"/> offer(s), <xsl:value-of select="count(CyclingRoutes/CyclingRoute)"/> route(s)
                </div>
            </div>
            <div class="tour-list">
                <xsl:apply-templates select="Tours/Tour"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="Tour">
        <div class="tour">
            <div class="title-line">
                <h3><xsl:value-of select="Title"/></h3>
                <span class="badge {Difficulty}">
                    <xsl:value-of select="Difficulty"/>
                </span>
                <span class="price">
                    <xsl:value-of select="BasePrice"/> <xsl:value-of select="BasePrice/@currency"/>
                </span>
                <span class="muted"><xsl:value-of select="DurationDays"/> days</span>
            </div>
            <div class="muted"><xsl:value-of select="Description"/></div>

            <table class="events">
                <thead>
                    <tr>
                        <th>Period</th>
                        <th>Max people</th>
                        <th>Guides</th>
                        <th>Routes</th>
                        <th>Bookings</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="TourEvents/TourEvent"/>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="TourEvent">
        <tr>
            <td>
                <xsl:value-of select="StartDate"/> → <xsl:value-of select="EndDate"/>
            </td>
            <td><xsl:value-of select="MaxParticipants"/></td>
            <td class="taglist">
                <xsl:for-each select="Guides/GuideRef">
                    <span>
                        <xsl:value-of select="key('kGuideById', @ref)/FirstName"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="key('kGuideById', @ref)/LastName"/>
                    </span>
                </xsl:for-each>
            </td>
            <td class="taglist">
                <xsl:for-each select="CyclingRoutes/CyclingRouteRef">
                    <span><xsl:value-of select="key('kRouteById', @ref)/Name"/></span>
                </xsl:for-each>
            </td>
            <td>
                <xsl:variable name="bookingsCount" select="count(key('kBookingsByEvent', @id))"/>
                <xsl:value-of select="$bookingsCount"/>
                <xsl:text> booking(s)</xsl:text>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
