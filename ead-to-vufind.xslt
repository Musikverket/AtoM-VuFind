<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Skriv ut lokal/specialkaraktärer som UTF-8 och prä-formattera outputtet på ett läsbart sätt -->
  <xsl:output encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <add overwrite="true">
      <xsl:apply-templates select="//c"/>
    </add>
  </xsl:template>
  <xsl:template match="c">
    <doc>
      <!-- Vi migrerar en hel samling, och då kommer top_id och top_title alltid vara samma (den samlingen vi migrerar). -->
      <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
      <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <!-- I näst-yttersta nivån av samlingshierarkien kommer parent vara en <dsc> tagg och inte en <c> tagg,
           så vi måste testa för detta när vi hittar parent_id och parent_title -->
      <xsl:choose>
        <xsl:when test="parent::c">
          <field name="hierarchy_parent_id"><xsl:value-of select="parent::c/did/unitid"/></field>
          <field name="hierarchy_parent_title"><xsl:value-of select="parent::c/did/unittitle"/></field>
        </xsl:when>
        <xsl:otherwise>
          <field name="hierarchy_parent_id"><xsl:value-of select="parent::dsc/parent::archdesc/did/unitid"/></field>
          <field name="hierarchy_parent_title"><xsl:value-of select="parent::dsc/parent::archdesc/did/unittitle"/></field>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Sortering av elementer på samma nivå i trädstrukturen. Här sorterar vi på unittitle. -->
      <field name="hierarchy_sequence"><xsl:value-of select="did/unittitle"/></field>
      <!-- id och title för den posten vi migrerar i samlingen -->
      <field name="hierarchy_id"><xsl:value-of select="did/unitid"/></field>
      <field name="hierarchy_title"><xsl:value-of select="did/unittitle"/></field>
      <!-- Skriva ut hela hierarkien till hierarchy_all_parents_str_mv, yttersta nivån ligger inte
           i en c-tagg så ska skrivas ut särskild -->
      <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="/ead/archdesc/did/unitid"/></field>
      <xsl:for-each select="ancestor::c">
        <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="did/unitid"/></field>
      </xsl:for-each>
    </doc>
  </xsl:template>
</xsl:stylesheet>
