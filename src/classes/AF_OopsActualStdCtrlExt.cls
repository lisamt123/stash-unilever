public with sharing class AF_OopsActualStdCtrlExt {
    //Members
    public String agencyId{get;set;}
    public String ParentId{get;set;}
    public String oopsActualId {get;set;}
    public String ParentRecordType {get;set;}
    public AF_OOPS_Actual__c oopsActual {get;set;}
    public Boolean noEstimates {get;set;}
    
    public AF_OopsActualStdCtrlExt(ApexPages.StandardController stdController) {
        
        oopsActualId = ApexPages.currentPage().getParameters().get('id');
        List<AF_OOPS_Actual__c> oopsActuals = [SELECT  AF_Agency_lk__c, Name,Overall__c,
                                                        (SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name,AF_Estimate__c
                                                            FROM OOPS_Estimates__r) 
                                                         FROM AF_OOPS_Actual__c 
                                                         WHERE Id =:oopsActualId LIMIT 1];
        for(AF_OOPS_Actual__c  eachOopsActual : oopsActuals) {
            oopsActual = eachOopsActual;
            agencyId = eachOopsActual.AF_Agency_lk__c;
            if(eachOopsActual.OOPS_Estimates__r.size() > 0) {
                noEstimates = true;
            }
        }
    } 
    
    
    public PageReference SaveRecord()
    {
        
        PageReference pageRef;
        try
        {   
                update oopsActual;
                pageRef = ApexPages.currentPage();
                pageRef.setRedirect(true);
        }
        catch(DMLException ex)
        {
                System.debug(ex);
            
            pageRef.setRedirect(true);
            pageRef = null;             
        }
         return pageRef;
        
    }
}