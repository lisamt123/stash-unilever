/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Company_Card__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_CompanyCardHandler implements ITrigger{   
    // Constructor
    public IPM_CompanyCardHandler (){
    	ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
    	//This method has been included as the class implements the ITrigger interface    
    }
    /** 
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
    	if(trigger.isUpdate){
            boolean isEditTrunOver=false;
            boolean isEditName=false;
            Set<Id>companyCEditSet=new Set<Id>();
            Set<Id>companyCReadSet=new Set<Id>();
            for(sobject ipmCard:trigger.new){
                IPM_Company_Card__c copmcard=(IPM_Company_Card__c )ipmCard;
                IPM_Company_Card__c  oldcopmcard = (IPM_Company_Card__c )trigger.oldMap.get(copmcard.Id) ;
                
                if(oldcopmcard.IPM_Total_OpCo_Turnover__c!=copmcard.IPM_Total_OpCo_Turnover__c || oldcopmcard.IPM_Company_Turnover__c!=copmcard.IPM_Company_Turnover__c){
                    companyCEditSet.add(oldcopmcard.id);
                }
                if(oldcopmcard.Name!=copmcard.Name || oldcopmcard.RecordTypeId!=copmcard.RecordTypeId || oldcopmcard.RecordType.Name!=copmcard.RecordType.Name){
                    companyCReadSet.add(oldcopmcard.id);
                }
            }
            
            if(!companyCEditSet.isEmpty()){
                isEditTrunOver=IPM_CompanyCardValidation.companyCCValidation(companyCEditSet);
                if(!isEditTrunOver){
                    trigger.new[0].adderror(system.label.IPM_Edit_Turnover_Company_Card);
                
                }
            }
            if(!companyCReadSet.isEmpty()){
                isEditName=IPM_CompanyCardValidation.companyCCNameValidation();
                if(!isEditName){
                    trigger.new[0].adderror(system.label.IPM_Edit_Company_Card_Name);
                }
            }
            
            
            
        }
    
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */    
    public void beforeInsert(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){   
		//This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){      
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so){   
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
		//Added by Devendra - call method to insert all exception logs got while excecution of trigger	 
		ExceptionLoggingHelper.insertLogRecordList();
    }
}