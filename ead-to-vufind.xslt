<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <add overwrite="true">
      <!-- Process the top record separately as it's not in a c-tag and doesn't have a parent record. -->
      <doc>
        <field name="record_format">atom</field>
        <field name="id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="institution"><xsl:value-of select="/ead/archdesc/did/repository/corpname"/></field>
        <field name="title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="title_full"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="title_short"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="collection"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="hierarchytype"/>
        <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="is_hierarchy_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="is_hierarchy_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <xsl:if test="/ead/archdesc/did/unitdate">
          <field name="dateSpan"><xsl:value-of select="/ead/archdesc/did/unitdate"/></field>
        </xsl:if>
        <xsl:if test="/ead/archdesc/did/physdesc">
          <field name="physical"><xsl:value-of select="/ead/archdesc/did/physdesc"/></field>
        </xsl:if>
        <xsl:if test="/ead/archdesc/controlaccess/subject">
          <field name="topic"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
          <field name="topic_facet"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
        </xsl:if>
        <!-- <field name="contents"><xsl:value-of select="/ead/archdesc/scopecontent"/></field> -->
        <xsl:apply-templates select="/ead/archdesc/scopecontent/p/text()"/>
      </doc>
      <xsl:apply-templates select="//c"/>
    </add>
  </xsl:template>
  <xsl:template match="text()">
    <field name="contents"><xsl:value-of select="current()"/></field>
  </xsl:template>
  <xsl:template match="c">
    <!-- In the second level below the top post, the parent is a <dsc> tag and not a <c> tag,
         so we need to test for this when we set parent_id and parent_title.
         We set them as "variables" (they are actually constants) so we can reuse them in hierarchy_browse -->
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
      <field name="record_format">atom</field>
      <!-- Limited set of metadata -->
      <field name="id"><xsl:value-of select="did/unitid"/></field>
      <field name="institution"><xsl:value-of select="did/repository/corpname"/></field>
      <field name="title"><xsl:value-of select="did/unittitle"/></field>
      <field name="title_full"><xsl:value-of select="did/unittitle"/></field>
      <field name="title_short"><xsl:value-of select="did/unittitle"/></field>
      <!-- We index an entire collection, so top_id and top_title will be the same for all records in
           the collection. -->
      <field name="collection"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <field name="hierarchytype"/>
      <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
      <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <!-- Set parent from the previously defined variables. -->
      <field name="hierarchy_parent_id"><xsl:value-of select="$parent_id"/></field>
      <field name="hierarchy_parent_title"><xsl:value-of select="$parent_title"/></field>
      <!-- Sort child elements on the same level in the hierarchy. Here we sort on unittitle. -->
      <field name="hierarchy_sequence"><xsl:value-of select="did/unittitle"/></field>
      <!-- Id and title for the record we want to index -->
      <field name="is_hierarchy_id"><xsl:value-of select="did/unitid"/></field>
      <field name="is_hierarchy_title"><xsl:value-of select="did/unittitle"/></field>
      <!-- Here we set hierarchy_browse to parent title and id (from the variables above).
           Required if the collection identifier is "All". -->
      <field name="hierarchy_browse"><xsl:value-of select="$parent_title"/>{{{_ID_}}}<xsl:value-of select="$parent_id"/></field>
      <!-- If the collection identifier is "Top", we need to set them with top_id och top_title instead: -->
      <!-- <field name="hierarchy_browse"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/>{{{_ID_}}}<xsl:value-of select="/ead/eadheader/eadid"/></field> -->
      <!-- Write out the entire hierarchy to hierarchy_all_parents_str_mv, the outermost level is not
           in a c-tag, so is written out separately -->
      <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="/ead/archdesc/did/unitid"/></field>
      <xsl:if test="did/physdesc">
        <field name="physical"><xsl:value-of select="did/physdesc"/></field>
      </xsl:if>
        <xsl:if test="did/unitdate">
          <field name="dateSpan"><xsl:value-of select="did/unitdate"/></field>
        </xsl:if>
      <xsl:if test="controlaccess/subject">
        <field name="topic"><xsl:value-of select="controlaccess/subject"/></field>
        <field name="topic_facet"><xsl:value-of select="controlaccess/subject"/></field>
      </xsl:if>
      <xsl:if test="/ead/archdesc/controlaccess/subject">
        <field name="topic"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
        <field name="topic_facet"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
      </xsl:if>
      <xsl:for-each select="ancestor::c">
        <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="did/unitid"/></field>
        <xsl:if test="controlaccess/subject">
          <field name="topic"><xsl:value-of select="controlaccess/subject"/></field>
          <field name="topic_facet"><xsl:value-of select="controlaccess/subject"/></field>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="scopecontent/p/text()"/>
      <!-- <field name="contents"><xsl:value-of select="scopecontent"/></field> -->
    </doc>
  </xsl:template>
</xsl:stylesheet>
