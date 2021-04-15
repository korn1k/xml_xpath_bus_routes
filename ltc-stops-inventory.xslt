<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="routeNumber" select="'default'"/>
    <xsl:param name="streetName" select="'default'"/>
    <xsl:template match="/">
        <h2>
            <font face="Verdana">
                <xsl:choose>
                    <xsl:when test="$routeNumber = 'default' and $streetName = 'default'">
                        All stops
                    </xsl:when>
                    <xsl:otherwise>
                                Stops on
                        <xsl:choose>
                            <xsl:when test="$routeNumber = 'default'">
                                <xsl:value-of select="$streetName" />
                            </xsl:when>
                            <xsl:when test="$streetName = 'default'">
                                <xsl:value-of select="$routeNumber" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$streetName" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </font>
        </h2>
        <h4>
            <xsl:choose>
                <xsl:when test="$routeNumber = 'default' and not($streetName = 'default')">
                    <xsl:value-of select="count(//stop[contains(@name, $streetName)])" /> stops found
                </xsl:when>
                <xsl:when test="$streetName = 'default' and not($routeNumber = 'default')">
                    <xsl:value-of select="count(//stop[contains(routes, $routeNumber)])" /> stops found
                </xsl:when>
                <xsl:when test="not($streetName = 'default') and not($routeNumber = 'default')">
                    <xsl:value-of select="count(//stop[contains(routes, $routeNumber) and contains(@name, $streetName)])" /> stops found
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(//stop)"/> stops found
                </xsl:otherwise>
            </xsl:choose>
            <!-- <xsl:value-of select="count(STOP[@name=$streetName])" /> stops found -->
        </h4>
        <table style="width:720px" border="3">
            <tr>
                <th>
                    <font face="Verdana" size="4">STOP #</font>
                </th>
                <th>
                    <font face="Verdana" size="4">Stop Name</font>
                </th>
                <th>
                    <font face="Verdana" size="4">Latitude</font>
                </th>
                <th>
                    <font face="Verdana" size="4">Longitude</font>
                </th>
                <th>
                    <font face="Verdana" size="4">Routes</font>
                </th>
            </tr>
            <xsl:apply-templates select ="//london-transit-data" />
        </table>
    </xsl:template>
    <xsl:template match="london-transit-data">
        <xsl:for-each select="stop">
            <xsl:sort select="@id" data-type="number" order="ascending"/>
            <xsl:choose>
                <xsl:when test="$routeNumber = 'default' and $streetName = 'default'">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="@name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@lattitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@longitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="routes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$routeNumber = 'default' and contains(@name, $streetName)">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="@name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@lattitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@longitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="routes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$streetName = 'default' and contains(routes, $routeNumber)">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="@name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@lattitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@longitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="routes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="contains(routes, $routeNumber) and contains(@name, $streetName)">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="@name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@lattitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="location/@longitude"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:value-of select="routes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>