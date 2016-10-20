public with sharing class BFM_MDFeHandler
    implements ITrigger
{   
    public BFM_MDFeHandler() {    
    }

    

  
    
    


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {
        if(trigger.isInsert){ 
            
            BFM_ValidationController.mdfeDuplicateRecordCheck(Trigger.New);
        } 
        if(trigger.isupdate){
            List<BFM_MDF_e__c> listmdfe = new list<BFM_MDF_e__c>();            
            for(BFM_MDF_e__c mdfe: (List<BFM_MDF_e__c> )trigger.new){
                if(mdfe.MDF_e_Sefaz_Status__c == 'Sefaz Ok'){
                    listmdfe.add(mdfe);
                }
            }
           
            if(!listmdfe.isEmpty()){
                BFM_Link_MDFCTe_onsave.linkmdfcte(listmdfe);
            }
        } 
    }
    
    public void bulkAfter()
    { 
         if(trigger.isInsert){
             set<id> setmdfeids = new set<id>();
             for(BFM_MDF_e__c mdfe: (List<BFM_MDF_e__c> )trigger.new){             
                 if(mdfe.MDF_e_Valid_CNPJ_Status__c=='Valid CNPJ' && mdfe.MDF_e_Sefaz_Status__c == null){
                    setmdfeids.add(mdfe.id);
                }
             }
              if(!setmdfeids.isEmpty()){
                BFM_Sefazvalidation_CC.sendMDFEtoSefaz(setmdfeids,'mdfe');
            }
         }
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
        //BFM_SefazCheck_Utility_CC.sefazcheck(mdfeRecord[0].id,'ddsfas','MDFE',userInfo.getSessionId());   
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