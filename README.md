# AtoM EAD to VuFind Solr

## Semantic and metadata fields
| Solr field                 | EAD field (informal description, see xslt for exact)                      | English term           | Swedish term            | Comments                                            |
|:---------------------------|:--------------------------------------------------------------------------|:-----------------------|:------------------------|:----------------------------------------------------|
| record_format              |                                                                           |                        |                         | Always 'atom'                                       |
| id                         | did/unitid                                                                |                        |                         |                                                     |
| institution                | /ead/eadheader/filedesc/publicationstmt/publisher                         | Repository             | Arkivinstitution        |                                                     |
| title                      | did/unittitle                                                             | Title                  | Titel                   |                                                     |
| title_full                 | did/unittitle                                                             |                        |                         |                                                     |
| title_short                | did/unittitle                                                             |                        |                         |                                                     |
| collection                 |                                                                           |                        |                         | Title of the top record the post belongs to         |
| reference_code_str         | @countrycode-@repositorycode-did/unitid                                   | Reference code         | Referenskod             |                                                     |
| level_of_description_str   | /ead/archdesc/@level                                                      | Level of description   | Beskrivningsnivå        |                                                     |
| physical                   | did/physdesc                                                              | Extent and medium      | Omfång och medium       |                                                     |
| archival_history_str       | /ead/archdesc/custodhist                                                  | Archival history       | Arkivhistorik           |                                                     |
| description_identifier_str | /ead/archdesc/odd[@type = 'descriptionIdentifier']                        | Description identifier | Beskrivningssignum      |                                                     |
| url                        | /ead/eadheader/eadid/@url and /ead/archdesc/did/dao[@linktype = 'simple'] |                        |                         | Link to record and link(s) to material              |
| topic                      | controlaccess/subject                                                     | Subject access points  | Sökingångar på ämne     |                                                     |
| topic_facet                | controlaccess/subject                                                     |                        |                         |                                                     |
| contents                   | scopecontent                                                              | Scope and content      | Omfattning och innehåll | Multivalue, each text-node becomes a contents field |

## Hierarchical fields
See [description on VuFind.org](https://vufind.org/wiki/indexing:hierarchies_and_collections)
* hierarchytype
* hierarchy_top_id
* hierarchy_top_title
* hierarchy_parent_id
* hierarchy_parent_title
* hierarchy_sequence
* is_hierarchy_id
* is_hierarchy_title
* hierarchy_browse
* hierarchy_all_parents_str_mv
* title_in_hierarchy
