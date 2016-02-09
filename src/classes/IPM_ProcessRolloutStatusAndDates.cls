/**
* @author       Cognizant
* @date         27/04/2015
* @description  This class is used for updating the rollout status and dates
*/

/* This class is being used to Set First and Follower on a rollout/Project , which needs access to all Rollout and 
   Projects associated with a project, hence has been set as Without Sharing.
*/

public without sharing class  IPM_ProcessRolloutStatusAndDates 
{
    /*******************************************************************************************************
    * @description                          Method used to process updation of Rollout Status
    * @param setTopLevelProjectIds          Set of Top Level Project Ids
    * @param setDeleteRolloutIds            Set of Rollouts that are being deleted
    * @return                               NONE
    */
    
    
    public static void execute(Set<Id> setTopLevelProjectIds,Set<Id> deleteRolloutIds)
    {
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
      
       
         if(!setTopLevelProjectIds.isEmpty())
         {
            List<IPM_Project__c> lstGlobalProjects = [SELECT Id,IPM_Parent_Project__c,IPMProject_Span__c,
                                                        // LOCAL ROLLOUT RELATED TO GLOBAL ORIGINAL 
                                                        (SELECT Id, Name, Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                            FROM IPM_Project_Rollout__r 
                                                            WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds ORDER By Target_Launch_Date__c),
                                                            
                                                        // LOCAL ROLLOUT IF IT IS REGIONAL ORIGINAL 
                                                        (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                            FROM Regional_Project_Rollout__r 
                                                            WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds order By Target_Launch_Date__c),
                                                            
                                                        (SELECT Id FROM IPM_Projects__r)
                                                      FROM IPM_Project__c 
                                                      WHERE Id IN: setTopLevelProjectIds LIMIT 50000];
        
         
           
           
           Map<Id,IPM_Project_Rollout__c> updatedRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
           
           Set<Id> globalMinimumSet = new Set<Id>();
           Set<Id> regionalMinimumSet = new Set<Id>();
           
           List<IPM_Project__c> regionalProjectList = new List<IPM_Project__c>();
           
           for(IPM_Project__c globalProject : lstGlobalProjects)
           {
                IPM_Project_Rollout__c minimumdateRollout = null;
                
                if(globalProject.IPM_Project_Rollout__r!= null && !globalProject.IPM_Project_Rollout__r.isEmpty())
                {
                    minimumdateRollout = globalProject.IPM_Project_Rollout__r[0];
                    regionalProjectList.addAll(globalProject.IPM_Projects__r);
                }
                else if(globalProject.Regional_Project_Rollout__r!= null && !globalProject.Regional_Project_Rollout__r.isEmpty())
                {
                    minimumdateRollout = globalProject.Regional_Project_Rollout__r[0];
                } 
                
                if (minimumdateRollout != null)
                {
                    if(globalProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                    {
                    	regionalMinimumSet.add(minimumdateRollout.Id);
                    }
                    else
                    {
                    	globalMinimumSet.add(minimumdateRollout.Id);
                    }
                }    
           }
           
         
           
           
           if(!regionalProjectList.isEmpty())
           {
                List<IPM_Project__c> lstRegionalProjects = [SELECT Id,
                                                            (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,
                                                                Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                                FROM Regional_Project_Rollout__r 
                                                                WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds  
                                                                order By Target_Launch_Date__c) 
                                                            FROM IPM_Project__c 
                                                            WHERE Id IN: regionalProjectList LIMIT 50000];
                for(IPM_Project__c regionalProject : lstRegionalProjects)
                {
                    IPM_Project_Rollout__c minimumdateRollout = null;
                    
                    if(regionalProject.Regional_Project_Rollout__r!= null && !regionalProject.Regional_Project_Rollout__r.isEmpty())
                    {
                        minimumdateRollout = regionalProject.Regional_Project_Rollout__r[0];
                        
                        if(updatedRolloutMap.containsKey(minimumdateRollout.Id))
                        {
                            minimumdateRollout = updatedRolloutMap.get(minimumdateRollout.Id);
                        }
                    
                        regionalMinimumSet.add(minimumdateRollout.Id);
                    } 
                }
           }
           
           
           
           for(IPM_Project__c globalProject : lstGlobalProjects)
           {
                List<IPM_Project_Rollout__c> relatedLocalRollout = new List<IPM_Project_Rollout__c>();
                if(globalProject.IPM_Project_Rollout__r!= null && !globalProject.IPM_Project_Rollout__r.isEmpty())
                {
                    relatedLocalRollout = globalProject.IPM_Project_Rollout__r;
                }
                else if(globalProject.Regional_Project_Rollout__r!= null && !globalProject.Regional_Project_Rollout__r.isEmpty())
                {
                    relatedLocalRollout = globalProject.Regional_Project_Rollout__r;
                }    
                
                for(IPM_Project_Rollout__c localRollout : relatedLocalRollout)
                {
                    if(globalMinimumSet.contains(localRollout.Id))
                    {
                        localRollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
                    }
                    else
                    {
                        localRollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                    }
                    
                    if(regionalMinimumSet.contains(localRollout.Id))
                    {
                        localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
                    }
                    else
                    {
                        localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;   
                    }
                    updatedRolloutMap.put(localRollout.Id,localRollout);
                }
           }
           
           
           
            if(!updatedRolloutMap.isEmpty())
            {
                IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;     
                update updatedRolloutMap.values();
                IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
            }
       }
    }
}