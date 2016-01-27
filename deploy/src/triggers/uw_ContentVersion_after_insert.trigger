trigger uw_ContentVersion_after_insert on ContentVersion (after update) {

    for(ContentVersion att : trigger.new) {
        try {
            // TODO: CheckMarx flagged this. In fact is it even necessary?
            // trigger.new contains the desired columns
            ContentVersion att_fromdb = [select id, CMS_ID__c from ContentVersion where id = :att.id];

            if(att_fromdb.CMS_ID__C ==null) {   
                att_fromdb.CMS_ID__C = att_fromdb.id  ;
                // TODO: CheckMarx flagged this. Update inside of a loop.
                update   att_fromdb;
            }
        } catch(exception e){}
    }
        
    /* new version, only do one SOQL query
       and one DML operation                
    try {
        Set<Id> setCV = uw_HelperMethods.makeIdSet(trigger.new);
        List<ContentVersion> cvsRequery = [SELECT id, cms_Id__c FROM ContentVersion WHERE id IN :(setCV)];
        for (ContentVersion cvRequery:cvsRequery) {
            if (cvRequery.cms_id__c == null) {
                cvRequery.cms_id__c = cvRequery.Id;
            }
        }
        update cvsRequery;       	
    } catch(Exception e) {    	
    }
 
    */
}