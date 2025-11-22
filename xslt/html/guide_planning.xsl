<?xml version="1.0" encoding="UTF-8"?>
<!--
  Scenario (HTML): Guide planning.
  - List each guide with the events they are assigned to.
  - Resolve TourEvent -> Tour -> Region to display context.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Keys -->
    <xsl:key name="kEventsByGuide" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent/Guides/GuideRef" use="@ref"/>
    <xsl:key name="kEvent" match="Operator/Regions/Region/Tours/Tour/TourEvents/TourEvent" use="@id"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Planning des guides</title>
                <style>
                    body { font-family: "Segoe UI", sans-serif; background: #f7f7f9; color: #1f2933; margin: 0; padding: 24px; }
                    h1 { text-align: center; color: #0f172a; }
                    .card { background: #fff; border-radius: 10px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); padding: 16px; margin-bottom: 16px; }
                    .muted { color: #6b7280; }
                    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    th { background: #0f172a; color: #fff; padding: 8px; text-align: left; }
                    td { padding: 8px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
                </style>
            </head>
            <body>
                <h1>Planning des guides</h1>
                <xsl:apply-templates select="Operator/Guides/Guide">
                    <xsl:sort select="LastName"/>
                    <xsl:sort select="FirstName"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Guide">
        <xsl:variable name="eventsRefs" select="key('kEventsByGuide', @id)"/>
        <div class="card">
            <h2><xsl:value-of select="FirstName"/><xsl:text> </xsl:text><xsl:value-of select="LastName"/></h2>
            <div class="muted">
                <xsl:value-of select="Email"/> — <xsl:value-of select="Phone"/> — Langues: <xsl:value-of select="Languages"/>
            </div>
            <div class="muted">Specialty: <xsl:value-of select="Specialty"/> — Exp: <xsl:value-of select="ExperienceYears"/> years</div>

            <table>
                <thead>
                    <tr>
                        <th>Period</th>
                        <th>Tour</th>
                        <th>Region</th>
                        <th>Difficulty</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:choose>
                        <xsl:when test="$eventsRefs">
                            <xsl:for-each select="$eventsRefs">
                                <xsl:variable name="event" select="ancestor::TourEvent[1]"/>
                                <xsl:variable name="tour" select="$event/ancestor::Tour[1]"/>
                                <xsl:variable name="region" select="$tour/ancestor::Region[1]"/>
                                <tr>
                                    <td><xsl:value-of select="$event/StartDate"/> → <xsl:value-of select="$event/EndDate"/></td>
                                    <td><xsl:value-of select="$tour/Title"/></td>
                                    <td><xsl:value-of select="$region/Name"/></td>
                                    <td><xsl:value-of select="$tour/Difficulty"/></td>
                                </tr>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr><td colspan="4" class="muted">No planned events</td></tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </tbody>
            </table>
        </div>
    </xsl:template>

</xsl:stylesheet>
