public with sharing class BFM_DebitNoteHandler
    implements ITrigger
{   
    public BFM_DebitNoteHandler() {    
    }

    

  
    
    


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    { 
        set<id> setdebitnote = new set<id>();
        for(BFM_Debit_Note__c dn:(List<BFM_Debit_Note__c>) trigger.new){
            if( dn.DN_Date_check_status__c =='Date Ok' || dn.Request_For_Cancellation__c == true || dn.Debit_Note_Definitive__c==true || dn.Debit_Note_Status__c=='Invoice Posted'){
                setdebitnote.add(dn.id);
            }
        }
        BFM_ValidationController.DebitNoteDuplicateRecordCheck(Trigger.New,setdebitnote,trigger.isinsert);
        BFM_DebitNote_CodeValidations.debitNoteCheck(Trigger.New,setdebitnote,trigger.isinsert);
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