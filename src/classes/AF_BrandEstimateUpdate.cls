global class AF_BrandEstimateUpdate implements Database.Batchable<sObject>{
    global string query = 'Select Id, Name, AF_Status_Base_Fees__c from AF_Brand_Estimate__c where Base_Fee_Total__c=0 and AF_Status_Base_Fees__c=\'Initiate\' and AF_Active__c=true';
    
    //Constructor
    global AF_BrandEstimateUpdate(){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,list<AF_Brand_Estimate__c> brandEstimateList){
        system.debug('brandEstimateList....'+brandEstimateList);
        AF_AgencyDate__c aD = AF_AgencyDate__c.getOrgDefaults();
        if(aD != null && aD.Agency_Trigger_Date__c == system.today()){
            if(brandEstimateList != null && !brandEstimateList.isEmpty()){
                for(AF_Brand_Estimate__c be : brandEstimateList){
                    be.AF_Status_Base_Fees__c='With Agency';
                }
            }
            
            try{
                update brandEstimateList;
            }catch(exception e){
                system.debug('***Exception Message-->'+e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
}