public with sharing class BFM_CTeHandler implements ITrigger
{   
    private Map<Id, BFM_Ct_e__c> oldMap;
    private Map<Id, BFM_Ct_e__c> newMap;
    
    public BFM_CTeHandler() {    
        
    }
    
    
    /**
* bulkBefore
*
* This method is called prior to execution of a BEFORE trigger. Use this to cache
* any data required into maps prior execution of the trigger.
*/
    public void bulkBefore()
    {  
        if(trigger.isinsert){ 
            BFM_ValidationController.cteDuplicateRecordCheck(Trigger.New);
            this.oldMap = (Map<Id, BFM_CT_e__c>) trigger.oldMap;
            this.newMap = (Map<Id, BFM_CT_e__c>) trigger.newMap;
        }
        if(trigger.isupdate){
            BFM_companyvendorcheck.companycodeandvendorcheck(Trigger.New);
        }  
    }
    
    public void bulkAfter()
    {
        
        
        if(trigger.isInsert){
            set<id> setcteids = new set<id>();
            for(BFM_CT_e__c cte: (List<BFM_CT_e__c> )trigger.new){             
                if(cte.CT_e_Valid_CNPJ_Status__c=='Valid CNPJ' && cte.CT_e_Sefaz_Check_Status__c== null){
                    setcteids.add(cte.id);
                }
                
            }
            
            if(!setcteids.isEmpty()){
                BFM_Sefazvalidation_CC.sendCTEtoSefaz(setcteids,'mdfe');
            }
        }
        
        if(Trigger.isupdate){
            set<id> setcodevalnfs = new set<id>();
            for(BFM_CT_e__c cte: (List<BFM_CT_e__c> )trigger.new){             
                
                if(cte.Link_Status__c=='Link Ok' || cte.CT_e_Request_for_Cancel__c==true || cte.cte_status__c == 'Invoice Posted'){
                    setcodevalnfs.add(cte.id);
                }
            }
            BFM_LinkSES.cteSESLink(Trigger.New,setcodevalnfs);
            BFM_TotalValueValidation.CteTotalValueValidation(Trigger.New);
            
            // Query tax
            for(Id idCte : trigger.newMap.keySet()){
                
                BFM_CT_e__c oldCte = (BFM_CT_e__c) trigger.oldMap.get(idCte);
                BFM_CT_e__c newCte = (BFM_CT_e__c) trigger.newMap.get(idCte);
                System.debug('new cte tax code ' +newCte.Tax_Code__r.Name);
                System.debug('old cte tax code '+oldCte.Tax_Code_id__c);
                if(newCte.Tax_Code_id__c != null && 
                   ((oldCte.Tax_Code_id__c == null) ||
                    (oldCte.Tax_Code_id__c != newCte.Tax_Code_id__c))){
                        System.debug('calling query tax future');
                        BFM_Querytax.queryTaxFuture(idCte);
                    }
            } 
        }
    }
    
    public void beforeInsert(SObject so)
    {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        
    }
    
    
    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so) 
    {
        /* BFM_CT_e__c cte = (BFM_CT_e__c) so;
if(cte.CT_e_Sefaz_Check_Status__c == null){
BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CTE',userInfo.getSessionId());
}*/
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this 
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally()
    {
        
    }
    
}