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
            BFM_POD__c pod = (BFM_POD__c)trigger.new[0];
            if(pod.recordtypeid == podRecordTypeId || pod.POD_as_Receipt__c){        
                BFM_ValidationController.podDuplicateRecordCheck(Trigger.New,trigger.isinsert, trigger.oldmap);  
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