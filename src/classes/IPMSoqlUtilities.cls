global class IPMSoqlUtilities {

    Global static String IPM_ProjectID{get;set;}
    
    
    public static Map<Id, IPM_Bosscard__c> getBosscardMap(){
        return getBosscardMap(null);
    }
    
    public static Map<Id, IPM_Bosscard__c> getBosscardMap(String recordId){
        String queryString = 'SELECT ';
        For (String field : Schema.SObjectType.IPM_Bosscard__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Bosscard__c';
        if (recordId != null)
            queryString+= ' WHERE Id =: recordId';
            
        queryString+= ' ORDER BY Name ASC ';
        
        return new Map<Id, IPM_Bosscard__c>((List<IPM_Bosscard__c>) Database.query(queryString));
    }    
}