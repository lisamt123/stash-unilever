/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Project_Document_Section__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialHandler implements ITrigger
{   
    Set<Id> associatedprojectRollouts = new Set<Id>();
    
    Set<Id> associatedTopLevelProjects = new Set<Id>();
    Set<Id> associatedRegionalProjects = new Set<Id>();
    Set<Id> associatedLocalProjects = new Set<Id>();
    
    Map<Id,IPM_Project__c> associatedProjectMap = new Map<Id,IPM_Project__c>();
    
    public static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    
    
    //@description:Constructor
    public IPM_FinancialHandler ()
    {
       ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
        IPM_FinancialTriggerHandler handler = new IPM_FinancialTriggerHandler();

        if(System.Trigger.isDelete)
        {
            handler.onBeforeDelete((Map<Id,IPM_Financial__c>) Trigger.oldMap);
        }

        if(Trigger.isInsert || Trigger.isUpdate )
        {
            for(IPM_Financial__c newFinancial : (List<IPM_Financial__c>)Trigger.New)
            {
                if(newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE)
                {
                    if(newFinancial.Parent_Project__c !=null)
                    {
                        associatedTopLevelProjects.add(newFinancial.Parent_Project__c);
                    }
                    
                    if(newFinancial.Regional_Project__c !=null)
                    {
                        associatedRegionalProjects.add(newFinancial.Regional_Project__c);
                    }
                    
                    if(newFinancial.Local_Project__c !=null)
                    {
                        associatedLocalProjects.add(newFinancial.Local_Project__c);
                    }
                }   
            }
        }
        
        //@@Design review - Data sharing - Code inserted for sharing the record with project owner queue 
        if(System.Trigger.isInsert)
        {
            handler.onBeforeInsert((List<IPM_Financial__c>) Trigger.new);
        }
        
        Set<Id> resultantProjects = new Set<Id>();
        resultantProjects.addAll(associatedTopLevelProjects);
        resultantProjects.addAll(associatedRegionalProjects);
        resultantProjects.addAll(associatedLocalProjects);
        
        associatedProjectMap = new Map <Id,IPM_Project__c>([Select Id,Name,IPM_Project_Rollout__c,IPM_Project_Rollout__r.Added_At_Stage__c,IPM_Project_Type__c,IPM_CompanyCardText__c from IPM_Project__c where Id in :resultantProjects LIMIT 50000]);
        
    }
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {
        IPM_FinancialTriggerHandler handler = new IPM_FinancialTriggerHandler();
        

        if(System.Trigger.isInsert)
        {
            handler.onAfterInsert((List<IPM_Financial__c>) Trigger.new);
        } 
        
        if(System.Trigger.isUpdate)
    {
            handler.onAfterUpdate((Map<Id,IPM_Financial__c>) Trigger.newMap, (Map<Id,IPM_Financial__c>) Trigger.oldMap);
            handler.updateFinancialActionStandard((Map<Id,IPM_Financial__c>) Trigger.newMap);
        }

    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
        IPM_Financial__c newfinancial = (IPM_Financial__c)so;
       if(newfinancial.Regional_Project__c !=null && newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE 
           && (String.isNotBlank(newFinancial.Financial_External_ID__c) && !newFinancial.Financial_External_ID__c.contains(IPM_ConstantUtils.FINANCIAL_NONKEY) )  )
        {
            Id regionalProjectId = newfinancial.Regional_Project__c;
            if(associatedProjectMap.containsKey(regionalProjectId))
            {
                IPM_Project__c project = associatedProjectMap.get(regionalProjectId);

                if(newfinancial.Charter_Approved__c)
                {
                    if( (project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPM_Project_Rollout__r.Added_At_Stage__c == IPM_ConstantUtils.ROLLOUT_COPYOVER_ELIGIBLE_PHASE) || 
                        project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )
                    {
                        newfinancial.Copy_Global_to_Regional__c = true;
                    }
                }
            }
        }
        
        if(newfinancial.Local_Project__c !=null && newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE)
        {
            Id localProjectId = newfinancial.Local_Project__c;
            if(associatedProjectMap.containsKey(localProjectId))
            {
                IPM_Project__c project = associatedProjectMap.get(localProjectId);
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
                {
                    if( project.IPM_Project_Rollout__r.Added_At_Stage__c == IPM_ConstantUtils.ROLLOUT_COPYOVER_ELIGIBLE_PHASE || 
                    project.IPM_CompanyCardText__c == IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL )
                    {
                        newfinancial.Copy_Regional_to_Local__c = true;
                    }
                }
            }
        }
        
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
        //This method has been included as the class implements the ITrigger interface
        IPM_Financial__c newfinancial = (IPM_Financial__c)so;
        IPM_Financial__c oldfinancial = (IPM_Financial__c)oldSo;
        
        if(newfinancial.Regional_Project__c !=null && newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE 
               && (String.isNotBlank(newFinancial.Financial_External_ID__c) && !newFinancial.Financial_External_ID__c.contains(IPM_ConstantUtils.FINANCIAL_NONKEY) ) )
        {
            Id regionalProjectId = newfinancial.Regional_Project__c;
            if(associatedProjectMap.containsKey(regionalProjectId))
            {
                IPM_Project__c project = associatedProjectMap.get(regionalProjectId);
                
                if(newfinancial.Charter_Approved__c && oldfinancial.Charter_Approved__c != newfinancial.Charter_Approved__c)
                {
                    if( (project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPM_Project_Rollout__r.Added_At_Stage__c == IPM_ConstantUtils.ROLLOUT_COPYOVER_ELIGIBLE_PHASE) || 
                        project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL  )
                    {
                        if(!oldfinancial.Copy_Global_to_Regional__c )
                        {
                            newfinancial.Copy_Global_to_Regional__c = true;
                        }
                    }
                }
                
            }
        }
        
       /* if(newfinancial.Local_Project__c !=null && newFinancial.RecordtypeID != CONSOLIDATED_FINANCIAL_RECORDTYPE)
        {
            Id localProjectId = newfinancial.Local_Project__c; 
            if(associatedProjectMap.containsKey(localProjectId))
            {
                IPM_Project__c project = associatedProjectMap.get(localProjectId);
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
                {
                    if( project.IPM_Project_Rollout__r.Added_At_Stage__c == IPM_ConstantUtils.ROLLOUT_COPYOVER_ELIGIBLE_PHASE || 
                        project.IPM_CompanyCardText__c == IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL )
                    {
                       /* if(!oldfinancial.Copy_Global_to_Local__c)
                        {
                            //newfinancial.Copy_Global_to_Local__c = true;
                        }
                        
                        if(!oldfinancial.Copy_Regional_to_Local__c)
                        {
                            //newfinancial.Copy_Regional_to_Local__c = true;
                        }
                    }
                }
            }
        }*/
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so)
    {      
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so) 
    {    
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally()
    {
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger  
        ExceptionLoggingHelper.insertLogRecordList();
    }
}