public with sharing class AF_BonusFeeStdCtrlExt {
    
    private final AF_Bonus_Summary__c bonusSummary;
    public String agencyId{get;set;}
    public String bonusSummaryId {get;set;}
    public Boolean noEstimates{get;set;}
    public String brandid{get;set;}
    public String Fyear{get;set;}
    public AF_BonusFeeStdCtrlExt(ApexPages.StandardController stdController) {
        noEstimates = false;
        bonusSummaryId = ApexPages.currentPage().getParameters().get('id');
        brandid=ApexPages.currentPage().getParameters().get('bId');
        Fyear=ApexPages.currentPage().getParameters().get('fy');
        agencyid=ApexPages.currentPage().getParameters().get('aId');
      
        List<AF_Bonus_Summary__c> bonusSummaries = [SELECT AF_Agency__c, Name,
                                                        (SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name
                                                            FROM Bonus_Matrix__r) 
                                                         FROM AF_Bonus_Summary__c 
                                                         WHERE Id =:bonusSummaryId LIMIT 1];
        for(AF_Bonus_Summary__c  eachRecord : bonusSummaries) {
           // agencyId = (eachRecord.AF_Agency__c)
           // brandid=eachRecord
            if(eachRecord.Bonus_Matrix__r.size() > 0) {
                noEstimates = true;
            }
        }
    }
}