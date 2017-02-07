public with sharing class BFM_CCeHandler implements ITrigger{   
    public BFM_CCeHandler() {}

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
*/
    public void bulkBefore() { 
        if(trigger.isInsert) {  
            BFM_ValidationController.cceDuplicateRecordCheck(Trigger.New);  
        }
    }
    
    public void bulkAfter() {
        if(trigger.isInsert){
            set<id> setcceids = new set<id>();
            for(BFM_CC_e__c cce: (List<BFM_CC_e__c> )trigger.new){             
                if(cce.CC_e_Link_Check_Status__c =='Link Ok' && cce.Sefaz_Check_Status__c== null){
                    setcceids.add(cce.id);
                }
            }
            if(!setcceids.isEmpty()){
                BFM_Sefazvalidation_CC.sendCCEtoSefaz(setcceids,'cce');
            }
        }  
    }
    
    public void beforeInsert(SObject so) {}
    
    public void beforeUpdate(SObject oldSo, SObject so) {}
     
    public void beforeDelete(SObject so) {}
    
    public void afterInsert(SObject so) {}
    
    public void afterUpdate(SObject oldSo, SObject so) {}
    
    public void afterDelete(SObject so) {}
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally() {}

}