// Controller class for the Force.com Typeahead component
global with sharing class Typeahead {

  @RemoteAction
  global static list<sObject> searchRecords( String queryString, String objectName, 
    list<String> fieldNames, String fieldsToSearch, String filterClause, String orderBy, Integer recordLimit ) {

    if (queryString == null) return null;
System.debug('-1................. ---queryString --------------------------------------' + queryString );
    String sQuery = String.escapeSingleQuotes( queryString );
    System.debug('-2................. ---sQuery --------------------------------------' + sQuery );
    if (sQuery.length() == 0) return null;

    String sObjectName = (objectName == null) ? 'Contact' : String.escapeSingleQuotes( objectName );
System.debug('-2................. ---sObjectName --------------------------------------' + sObjectName );
    String sInFields = 
        (fieldsToSearch == null || fieldsToSearch == '' || fieldsToSearch.toUpperCase() == 'ALL') ? '' : 
            ( ' IN ' + String.escapeSingleQuotes(fieldsToSearch) + ' FIELDS' );
    System.debug('-2................. ---sInFields --------------------------------------' + sInFields );
    String sFields = (fieldNames == null || fieldNames.isEmpty()) ? 'Id, Name' : 
            String.escapeSingleQuotes( String.join( fieldNames, ', ' ) ); 
        System.debug('-2................. ---sFields --------------------------------------' + sFields );    
        System.debug('12345'+sFields) ;
    
    String sOrder = ' ORDER BY ' + ( (orderBy == null || orderBy == '') ? 'Name' : String.escapeSingleQuotes(orderBy) ); 
     System.debug('****---------------------------------------*'+sOrder) ;
     
    String sLimit = (recordLimit == null || recordLimit == 0 || recordLimit >= 2000) ? '' : 
        ( ' LIMIT ' + String.valueOf(recordLimit));
     System.debug('**sLimit *---------------------------------------*'+sLimit ) ;
     
    // can't escape the filter clause
    String sWhere = (filterClause == null || filterClause == '') ? '' : 
        ( ' WHERE ' + filterClause );
   System.debug('------------Filter Clause-------------------------------------'+sWhere) ;
   
   String query123 = ' \'FIND \'' + sQuery + '*\'' + sInFields + ' RETURNING ' + sObjectName + '( ' + sFields + sWhere + sOrder + sLimit + ' )';
    System.debug('?????---------query123 ----------------------------'+query123 ) ;
   
   
    list<list<sObject>> results = Search.query(
        'FIND \'' + sQuery + '*\'' + sInFields + 
            ' RETURNING ' + sObjectName + '( ' + sFields + sWhere + sOrder + sLimit + ' )'
    );
    System.debug('?????---------results ----------------------------'+results ) ;
    
    return results[0];
  }  

}