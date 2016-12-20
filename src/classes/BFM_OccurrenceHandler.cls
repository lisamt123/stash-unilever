public class BFM_OccurrenceHandler implements ITrigger {
    public BFM_OccurrenceHandler() {    
    }
    
    /**
* bulkBefore
*
* This method is called prior to execution of a BEFORE trigger. Use this to cache
* any data required into maps prior execution of the trigger.
*/
    public void bulkBefore()
    { 
        System.debug(trigger.new);
        List<BFM_Occurrence__c> newMap = (List<BFM_Occurrence__c>)trigger.new;
        Set<String> carrierVendorCodes = new Set<String>();
        for(BFM_Occurrence__c occ: newMap){
            carrierVendorCodes.add(occ.carrier__c);
        }
        Map<String, Account> accountByVendorCode = new Map<String, Account>();
        for(Account acc: [SELECT Vendor__c FROM Account WHERE Vendor__c IN: carrierVendorCodes]){
            accountByVendorCode.put(acc.vendor__c, acc );
        }
        
            for(BFM_Occurrence__c occ : newMap){
                if(occ.carrier_account__c!=null){
                  occ.carrier_account__c = accountByVendorCode.get(occ.carrier__c).Id;
            }
        }
    }
    
    public void bulkAfter()
    {
        //This method has been included as the class implements the ITrigger interface  
    }
    
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface    
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        //This method has been included as the class implements the ITrigger interface   
    }
    
    
    public void beforeDelete(SObject so)
    { 
        //This method has been included as the class implements the ITrigger interface  
    }
    
    public void afterInsert(SObject so) 
    { 
        //This method has been included as the class implements the ITrigger interface
        // BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CCE',userInfo.getSessionId());
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterDelete(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this 
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally()
    {
        //This method has been included as the class implements the ITrigger interface   
    }
}