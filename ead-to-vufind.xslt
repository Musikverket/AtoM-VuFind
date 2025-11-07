<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Skriv ut lokal/specialkaraktärer som UTF-8 och prä-formattera outputtet på ett läsbart sätt -->
  <xsl:output encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <add overwrite="true">
      <!-- Top-posten läggas in separat och särbehandlas då den inte ligger i en c-tagg och inte har någon parent -->
      <doc>
        <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="hierarchy_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="hierarchy_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      </doc>
      <xsl:apply-templates select="//c"/>
    </add>
  </xsl:template>
  <xsl:template match="c">
    <!-- I näst-yttersta nivån av samlingshierarkien kommer parent vara en <dsc> tagg och inte en <c> tagg,
         så vi måste testa för detta när vi hittar parent_id och parent_title.
         Vi sätter dem som variabler då vi kan komma att återanvända dessa värden även i hierarchy_browse -->
    <xsl:variable name="parent_id">
      <xsl:choose>
        <xsl:when test="parent::c">
          <xsl:value-of select="parent::c/did/unitid"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="parent::dsc/parent::archdesc/did/unitid"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="parent_title">
      <xsl:choose>
        <xsl:when test="parent::c">
          <xsl:value-of select="parent::c/did/unittitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="parent::dsc/parent::archdesc/did/unittitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <doc>
      <!-- Vi migrerar en hel samling, och då kommer top_id och top_title alltid vara samma (den samlingen vi migrerar). -->
      <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
      <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <!-- Parents sättas nu från variablerna vi definierade ovan -->
      <field name="hierarchy_parent_id"><xsl:value-of select="$parent_id"/></field>
      <field name="hierarchy_parent_title"><xsl:value-of select="$parent_title"/></field>
      <!-- Sortering av elementer på samma nivå i trädstrukturen. Här sorterar vi på unittitle. -->
      <field name="hierarchy_sequence"><xsl:value-of select="did/unittitle"/></field>
      <!-- id och title för den posten vi migrerar i samlingen -->
      <field name="hierarchy_id"><xsl:value-of select="did/unitid"/></field>
      <field name="hierarchy_title"><xsl:value-of select="did/unittitle"/></field>
      <!-- Här sättas hierarchy_browse till parent title och id (från variablerna som sättas i början).
           Krävs om collection identifier är "All". -->
      <field name="hierarchy_browse"><xsl:value-of select="$parent_title"/>{{{_ID_}}}<xsl:value-of select="$parent_id"/></field>
      <!-- Om collection identifier är "Top" måste vi sätta denna med top_id och top_title. Använd då följande istället. -->
      <!-- <field name="hierarchy_browse"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/>{{{_ID_}}}<xsl:value-of select="/ead/eadheader/eadid"/></field> -->
      <!-- Skriva ut hela hierarkien till hierarchy_all_parents_str_mv, yttersta nivån ligger inte
           i en c-tagg så ska skrivas ut särskild -->
      <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="/ead/archdesc/did/unitid"/></field>
      <xsl:for-each select="ancestor::c">
        <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="did/unitid"/></field>
      </xsl:for-each>
    </doc>
  </xsl:template>
</xsl:stylesheet>
