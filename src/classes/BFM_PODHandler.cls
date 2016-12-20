public with sharing class BFM_PODHandler
    implements ITrigger
{   
    public BFM_PODHandler() {    
    }

    

  
    
    


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    { 
        if(trigger.isUpdate){
            Id podRecordTypeId = Schema.SObjectType.BFM_POD__c.getRecordTypeInfosByName().get('POD').getRecordTypeId();
            system.debug('podRecordTypeId:'+podRecordTypeId);
            BFM_POD__c pod = (BFM_POD__c)trigger.new[0];
            system.debug('pod:'+pod);
            if(pod.recordtypeid == podRecordTypeId || pod.POD_as_Receipt__c == false){        
                BFM_ValidationController.podDuplicateRecordCheck(Trigger.New,trigger.isinsert, trigger.oldmap);  
            }  
        }      
    }
    
    public void bulkAfter()
    {
        
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
      BFM_POD__c pod = (BFM_POD__c) so;                 
           if(pod.POD_Status__c=='provisional'&& pod.POD_Date__c!= null && pod.NF_e__c!=null){
                BFM_SavePOD.sendPOD(pod.id);    
            }  
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        BFM_POD__c pod = (BFM_POD__c) so;                 
           if((pod.POD_Status__c=='provisional' || pod.POD_Status__c=='Definitive' )&& pod.POD_Date__c!= null && pod.NF_e__c!=null){
                BFM_SavePOD.sendPOD(pod.id);    
            }
      
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