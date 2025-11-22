<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (HTML): Client invoice per booking.
  For each Booking (now nested under TourEvent/EventBookings), the template resolves:
    - Client identity via ClientRef -> Clients/Client.
    - Event context via ancestor::TourEvent -> ancestor Tour/Region.
    - Guides via GuideRef, routes via CyclingRouteRef.
    - Bikes via BookedBike/@ref -> Bikes/Bike.
    - Payments with total amount.
  Output: structured invoice-style HTML.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Keys for fast lookup -->
    <xsl:key name="kClient" match="Operator/Clients/Client" use="@id"/>
    <xsl:key name="kGuide" match="Operator/Guides/Guide" use="@id"/>
    <xsl:key name="kRoute" match="Operator/Regions/Region/CyclingRoutes/CyclingRoute" use="@id"/>
    <xsl:key name="kBike" match="Operator/Regions/Region/Bikes/Bike" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Client Invoices</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    .invoice { background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); padding: 20px; margin-bottom: 24px; }
                    .header { display: flex; justify-content: space-between; align-items: baseline; }
                    .muted { color: #6b7280; }
                    .section-title { margin-top: 14px; font-weight: 600; color: #0f172a; }
                    table { width: 100%; border-collapse: collapse; margin-top: 8px; }
                    th { background: #0f172a; color: #fff; padding: 8px; text-align: left; }
                    td { padding: 8px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
                    .badge { padding: 4px 8px; border-radius: 10px; color: #fff; font-size: 0.85em; }
                    .Easy { background: #16a34a; }
                    .Moderate { background: #f59e0b; }
                    .Hard { background: #dc2626; }
                    .total { font-weight: 700; color: #0ea5e9; }
                </style>
            </head>
            <body>
                <h1>Client invoices</h1>
                <xsl:apply-templates select="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent/EventBookings/Booking">
                    <xsl:sort select="BookingDate"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Booking">
        <!-- Resolve related entities via keys; ancestor::* picks the owning Tour/Region for context -->
        <xsl:variable name="client" select="key('kClient', ClientRef)"/>
        <xsl:variable name="event" select="ancestor::TourEvent[1]"/>
        <xsl:variable name="tour" select="$event/ancestor::Tour[1]"/>
        <xsl:variable name="region" select="$tour/ancestor::Region[1]"/>
        <xsl:variable name="bookingId" select="@id"/>
        <xsl:variable name="eventBookings" select="count($event/EventBookings/Booking)"/>

        <div class="invoice">
            <div class="header">
                <div>
                    <div class="muted">Invoice</div>
                    <div>Booking <strong><xsl:value-of select="$bookingId"/></strong> — <xsl:value-of select="BookingDate"/></div>
                </div>
                <div class="muted">
                    <xsl:text>Max participants: </xsl:text><xsl:value-of select="$event/MaxParticipants"/>
                    <xsl:text> · Bookings on event: </xsl:text><xsl:value-of select="$eventBookings"/>
                </div>
            </div>

            <div class="section-title">Client</div>
            <div>
                <xsl:value-of select="$client/FirstName"/><xsl:text> </xsl:text><xsl:value-of select="$client/LastName"/>
                <xsl:text> — </xsl:text><xsl:value-of select="$client/Email"/>
                <xsl:text> — </xsl:text><xsl:value-of select="$client/Phone"/>
            </div>

            <div class="section-title">Trip</div>
            <div>
                <strong><xsl:value-of select="$tour/Title"/></strong>
                <xsl:text> (</xsl:text><xsl:value-of select="$region/Name"/><xsl:text>, </xsl:text><xsl:value-of select="$region/Country"/><xsl:text>)</xsl:text>
                <xsl:text> — </xsl:text><xsl:value-of select="$tour/DurationDays"/><xsl:text> days</xsl:text>
                <xsl:text> — </xsl:text><span class="badge { $tour/Difficulty }"><xsl:value-of select="$tour/Difficulty"/></span>
            </div>
            <div class="muted">
                <xsl:text>Dates: </xsl:text><xsl:value-of select="$event/StartDate"/><xsl:text> → </xsl:text><xsl:value-of select="$event/EndDate"/>
            </div>

            <div class="section-title">Guides</div>
            <div class="muted">
                <xsl:for-each select="$event/Guides/GuideRef">
                    <xsl:if test="position() &gt; 1">, </xsl:if>
                    <xsl:value-of select="key('kGuide', @ref)/FirstName"/><xsl:text> </xsl:text><xsl:value-of select="key('kGuide', @ref)/LastName"/>
                </xsl:for-each>
            </div>

            <div class="section-title">Cycling routes</div>
            <div class="muted">
                <xsl:for-each select="$event/CyclingRoutes/CyclingRouteRef">
                    <xsl:if test="position() &gt; 1">, </xsl:if>
                    <xsl:value-of select="key('kRoute', @ref)/Name"/>
                </xsl:for-each>
            </div>

        <div class="section-title">Booked bikes</div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Type</th>
                    </tr>
                </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="BookedBikes/BookedBike">
                        <xsl:apply-templates select="BookedBikes/BookedBike"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td colspan="4" class="muted">No booked bikes</td></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>

        <div class="section-title">Payments</div>
        <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Method</th>
                    </tr>
                </thead>
            <tbody>
                    <xsl:apply-templates select="Payments/Payment"/>
                    <tr>
                        <td colspan="3" class="total">
                            Total paid: <xsl:value-of select="format-number(sum(Payments/Payment/Amount), '0.00')"/> <xsl:value-of select="Payments/Payment[1]/Amount/@currency"/>
                        </td>
                    </tr>
        </tbody>
        </table>
    </div>
    </xsl:template>

    <xsl:template match="BookedBike">
        <xsl:variable name="bike" select="key('kBike', @ref)"/>
        <tr>
            <td><xsl:value-of select="@ref"/></td>
            <td><xsl:value-of select="$bike/Brand"/></td>
            <td><xsl:value-of select="$bike/Model"/></td>
            <td><xsl:value-of select="$bike/Type"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="Payment">
        <tr>
            <td><xsl:value-of select="Date"/></td>
            <td><xsl:value-of select="Amount"/> <xsl:value-of select="Amount/@currency"/></td>
            <td><xsl:value-of select="Method"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
