<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <add overwrite="true">
      <!-- Process the top record separately as it's not in a c-tag and doesn't have a parent record. -->
      <doc>
        <!-- Supposed to direct VuFind to use a custom SolrAtom driver but I didn't quite manage to make this work -->
        <field name="record_format">atom</field>

        <!-- Basic metadata -->
        <field name="id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="institution"><xsl:value-of select="/ead/eadheader/filedesc/publicationstmt/publisher"/></field>
        <field name="title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <!-- Use if we want to apply description level to top record
        <field name="title">
          <xsl:text>[</xsl:text>
          <xsl:call-template name="levelTranslation">
            <xsl:with-param name="level" select="/ead/archdesc/@level"/>
          </xsl:call-template>
          <xsl:text>] </xsl:text>
          <xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/>
        </field> -->
        <field name="title_full"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="title_short"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="collection"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>

        <!-- Hierarchical data for the root record -->
        <field name="hierarchytype"/>
        <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="is_hierarchy_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
        <field name="is_hierarchy_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
        <field name="reference_code_str">
          <xsl:value-of select="/ead/archdesc/did/unitid/@countrycode"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="/ead/archdesc/did/unitid/@repositorycode"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="/ead/archdesc/did/unitid"/>
        </field>
        <field name="level_of_description_str"><xsl:value-of select="/ead/archdesc/@level"/></field>
        <!-- <field name="title_in_hierarchy">
          <xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/>
        </field> -->

        <!-- Dates field. The date here can serve a number of purposes in AtoM (created, archived, etc), but this does
             not for the moment carry over in the EAD output -->
        <xsl:if test="/ead/archdesc/did/unitdate">
          <field name="dates_str"><xsl:value-of select="/ead/archdesc/did/unitdate"/></field>
        </xsl:if>
        <!-- Physical description -->
        <xsl:if test="/ead/archdesc/did/physdesc">
          <field name="physical"><xsl:value-of select="/ead/archdesc/did/physdesc"/></field>
        </xsl:if>
        <!-- Subject access points -->
        <xsl:if test="/ead/archdesc/controlaccess/subject">
          <field name="topic"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
          <field name="topic_facet"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
        </xsl:if>
        <!-- Link to AtoM record -->
        <field name="url"><xsl:value-of select="/ead/eadheader/eadid/@url"/></field>
        <!-- Link to AtoM fulltext -->
        <xsl:if test="/ead/archdesc/did/dao[@linktype = 'simple']">
          <field name="url"><xsl:value-of select="/ead/archdesc/did/dao/@href"/></field>
        </xsl:if>
        <!-- Table of contents -->
        <xsl:apply-templates select="/ead/archdesc/scopecontent/p/text()"/>
      </doc>
      <xsl:apply-templates select="//c"/>
    </add>
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
      <!-- Basic metadata -->
      <field name="id"><xsl:value-of select="did/unitid"/></field>
      <field name="institution"><xsl:value-of select="/ead/eadheader/filedesc/publicationstmt/publisher"/></field>
      <field name="title"><xsl:value-of select="did/unittitle"/></field>
      <field name="title_full"><xsl:value-of select="did/unittitle"/></field>
      <field name="title_short"><xsl:value-of select="did/unittitle"/></field>
      <!-- Hierarchical data -->
      <!-- We index an entire collection, so top_id and top_title will be the same for all records in
           the collection. -->
      <field name="collection"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <field name="hierarchytype"/>
      <field name="hierarchy_top_id"><xsl:value-of select="/ead/eadheader/eadid"/></field>
      <field name="hierarchy_top_title"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/></field>
      <!-- Set parent from the previously defined variables. -->
      <field name="hierarchy_parent_id"><xsl:value-of select="$parent_id"/></field>
      <field name="hierarchy_parent_title"><xsl:value-of select="$parent_title"/></field>
      <!-- Sort child elements on the same level in the hierarchy. Here we sort on unitid. -->
      <field name="hierarchy_sequence"><xsl:value-of select="did/unitid"/></field>
      <!-- Id and title for the record we want to index -->
      <field name="is_hierarchy_id"><xsl:value-of select="did/unitid"/></field>
      <field name="is_hierarchy_title"><xsl:value-of select="did/unittitle"/></field>

      <field name="reference_code_str">
        <xsl:value-of select="/ead/archdesc/did/unitid/@countrycode"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/ead/archdesc/did/unitid/@repositorycode"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="did/unitid"/>
      </field>
      <!-- Pick out Level of description based on presence of "otherlevel" attribute -->
      <xsl:choose>
        <xsl:when test="@level='otherlevel'">
          <field name="level_of_description_str"><xsl:value-of select="@otherlevel"/></field>
        </xsl:when>
        <xsl:otherwise>
          <field name="level_of_description_str"><xsl:value-of select="@level"/></field>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Here we set hierarchy_browse to parent title and id (from the variables above).
           Required if the collection identifier is "All". -->
      <field name="hierarchy_browse"><xsl:value-of select="$parent_title"/>{{{_ID_}}}<xsl:value-of select="$parent_id"/></field>
      <!-- If the collection identifier is "Top", we need to set them with top_id och top_title instead: -->
      <!-- <field name="hierarchy_browse"><xsl:value-of select="/ead/eadheader/filedesc/titlestmt/titleproper"/>{{{_ID_}}}<xsl:value-of select="/ead/eadheader/eadid"/></field> -->
      <!-- Write out the entire hierarchy to hierarchy_all_parents_str_mv, the outermost level is not
           in a c-tag, so is written out separately -->
      <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="/ead/archdesc/did/unitid"/></field>
      <xsl:for-each select="ancestor::c">
        <field name="hierarchy_all_parents_str_mv"><xsl:value-of select="did/unitid"/></field>
        <xsl:if test="controlaccess/subject">
          <field name="topic"><xsl:value-of select="controlaccess/subject"/></field>
          <field name="topic_facet"><xsl:value-of select="controlaccess/subject"/></field>
        </xsl:if>
      </xsl:for-each>
      <field name="title_in_hierarchy">
        <xsl:text>[</xsl:text>
        <xsl:choose>
          <xsl:when test="@level='otherlevel'">
            <xsl:call-template name="levelTranslation">
              <xsl:with-param name="level" select="@otherlevel"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="levelTranslation">
              <xsl:with-param name="level" select="@level"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>] </xsl:text>
        <xsl:value-of select="did/unittitle"/>
      </field>

      <!-- Physical description -->
      <xsl:if test="did/physdesc">
        <field name="physical"><xsl:value-of select="did/physdesc"/></field>
      </xsl:if>
      <!-- Dates field. The date here can serve a number of purposes in AtoM (created, archived, etc), but this does
           not for the moment carry over in the EAD output -->
      <xsl:if test="did/unitdate">
        <field name="dates_str"><xsl:value-of select="did/unitdate"/></field>
      </xsl:if>
      <xsl:if test="controlaccess/subject">
        <field name="topic"><xsl:value-of select="controlaccess/subject"/></field>
        <field name="topic_facet"><xsl:value-of select="controlaccess/subject"/></field>
      </xsl:if>
      <!-- Subject access points -->
      <xsl:if test="/ead/archdesc/controlaccess/subject">
        <field name="topic"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
        <field name="topic_facet"><xsl:value-of select="/ead/archdesc/controlaccess/subject"/></field>
      </xsl:if>
      <!-- Table of contents -->
      <xsl:apply-templates select="scopecontent/p/text()"/>
    </doc>
  </xsl:template>
  <xsl:template match="text()">
    <field name="contents"><xsl:value-of select="current()"/></field>
  </xsl:template>
  <!-- Baked-in translation of decription levels -->
  <xsl:template name="levelTranslation">
    <xsl:param name="level"/>
    <xsl:choose>
      <xsl:when test="$level='fonds'">
        <xsl:text>Arkiv</xsl:text>
      </xsl:when>
      <xsl:when test="$level='collection'">
        <xsl:text>Samling</xsl:text>
      </xsl:when>
      <xsl:when test="$level='series'">
        <xsl:text>Serie</xsl:text>
      </xsl:when>
      <xsl:when test="$level='heading'">
        <xsl:text>Rubrik</xsl:text>
      </xsl:when>
      <xsl:when test="$level='volume'">
        <xsl:text>Volym</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
