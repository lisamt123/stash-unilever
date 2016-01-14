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
    * @param setGlobalProjectIds            Set of Global Project Ids
    * @param setRegionalOriginalProjectIds  Set of Regional Original Project Ids
    * @return                               NONE
    */
    public static void execute(Set<Id> setGlobalProjectIds, Set<Id> setRegionalOriginalProjectIds)
    {
        execute(setGlobalProjectIds, setRegionalOriginalProjectIds, new Set<String>());
       
    }
    
    /*******************************************************************************************************
    * @description                          Method used to process updation of Rollout Status
    * @param setGlobalProjectIds            Set of Global Project Ids
    * @param setRegionalOriginalProjectIds  Set of Regional Original Project Ids
    * @param setDeleteRolloutIds            Set of Rollouts that are being deleted
    * @return                               NONE
    */
    
    
    public static void execute(Set<Id> setGlobalProjectIds, Set<Id> setRegionalOriginalProjectIds, Set<String> setDeleteRolloutIds)
    {
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        
       
         if(!setGlobalProjectIds.isEmpty())
         {
            List<IPM_Project__c> lstGlobalProjects = [SELECT Id, 
                                                      (SELECT Id, Name, Target_Launch_Date__c, IPM_Status__c, Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                       FROM IPM_Project_Rollout__r 
                                                       WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE ),
                                                      //AND Regional_Project__c =: null),
                                                      (SELECT Id 
                                                       FROM IPM_Projects__r)
                                                      FROM IPM_Project__c 
                                                      WHERE IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL AND Id IN: setGlobalProjectIds LIMIT 50000];
        
         
         
            
         
             Set<Id> setRegionalProjectIds = new Set<Id>();
             
             for(IPM_Project__c globalProject : lstGlobalProjects)
             {
               for(IPM_Project__c regionalProject : globalProject.IPM_Projects__r)
               {
                        setRegionalProjectIds.add(regionalProject.Id);
               }       
             }
            
            
            setRolloutStatus(setRegionalProjectIds,setGlobalProjectIds);
            
        }
        if(!setRegionalOriginalProjectIds.isEmpty())
        {            
            
            setRolloutStatus(setRegionalOriginalProjectIds,null);
        }
    }
   
  public static void setRolloutStatus(Set<Id> setRegionalProjectIds, Set<Id> setGlobalProjectIds)
  {
     String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
     String REGIONAL_ROLLOUT_RECORDTYPE =Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object cant delete it using in the query below
     Map<Id,IPM_Project_Rollout__c> updateRolloutStatusMap = new Map<Id,IPM_Project_Rollout__c>();
     Map<Id,IPM_Project_Rollout__c> globalLocalRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
     Boolean isLeaderFound = false;
     Boolean isRegionalLeaderFound = false;
     
     // in case of regional rollout  IPM_Project__c this will give me global project and in case of regional project IPM_Parent_Project__c will give me parent project
     
     List<IPM_Project__c> listRelatedProjects = [SELECT Id,Name,IPMProject_Span__c,IPM_Parent_Project__c,
                                                      (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                       FROM IPM_Project_Rollout__r 
                                                       WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE ORDER BY Target_Launch_Date__c),
                                                      
                                                      (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                       FROM Regional_Project_Rollout__r  WHERE (NOT Regional_Project__c =: null) AND RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE  ORDER BY Target_Launch_Date__c),
                                                      
                                                      (SELECT Id,Name,IPM_Target_Launch_Dates__c,IPM_RolloutStatus__c, IPM_Parent_Project__r.IPM_Parent_Project__c 
                                                        FROM IPM_Projects__r) 
                                                       
                                                      FROM IPM_Project__c 
                                                      WHERE (IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL AND Id IN: setGlobalProjectIds) OR (IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL AND Id IN :setRegionalProjectIds) LIMIT 50000];

      
      Id sortedGlobalLocalRollout;
      if(listRelatedProjects != NULL && !listRelatedProjects.isEmpty())
      {
       for(IPM_Project__c globalProject : listRelatedProjects)
       {
          //Process Local Rollouts we need to check this one also for first and follower it will run for all local rollout
          isRegionalLeaderFound = false;
          for(IPM_Project_Rollout__c localRollout : globalProject.IPM_Project_Rollout__r)
          {
              if(!isLeaderFound) 
              {   
                    localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                    isLeaderFound = true;
                    sortedGlobalLocalRollout = localRollout.id;
                    
              }
              else
              {
                localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                
              }                
            
                updateRolloutStatusMap.put(localRollout.id,localRollout);
            
            
            
             // for multiple regional project
                if(!isRegionalLeaderFound)
                {
                    localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
                    isRegionalLeaderFound = true;
                }
                
                else
                {
                    localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                    
                }
            
                updateRolloutStatusMap.put(localRollout.id,localRollout);   
            
            
          }  
             
       }
  
    }
    if(!updateRolloutStatusMap.isEmpty())
    {
        IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
        update updateRolloutStatusMap.values();
        IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
            
    }
     
    // for access updated values of local rollout status 
     
     if(setRegionalProjectIds!= null && !setRegionalProjectIds.isEmpty())
     {
        List<IPM_Project__c> lstRegionalProjectUpdated = [SELECT Id, IPM_Parent_Project__c, IPM_Target_Launch_Dates__c,IPMProject_Span__c,
                                                    
                                                    (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                       FROM Regional_Project_Rollout__r  WHERE (NOT Regional_Project__c =: null) AND RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE  ORDER BY Target_Launch_Date__c),
                                                    
                                                    (SELECT Id,Name,IPM_Target_Launch_Dates__c,IPM_RolloutStatus__c, IPM_Parent_Project__r.IPM_Parent_Project__c 
                                                        FROM IPM_Projects__r) 
                                                     
                                                    FROM IPM_Project__c 
       
                                                    WHERE IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL AND Id IN: setRegionalProjectIds LIMIT 50000];
        
       
       isLeaderFound = false;
       if(listRelatedProjects != NULL && !listRelatedProjects.isEmpty())
       {
        for(IPM_Project__c globalProject : listRelatedProjects)
        { 
            if(lstRegionalProjectUpdated!= null && !lstRegionalProjectUpdated.isEmpty())
            {
                for(IPM_Project__c regionalProject : lstRegionalProjectUpdated)
                {
                    isRegionalLeaderFound = false;
                    //Process Local Rollouts
                    for(IPM_Project_Rollout__c localRollout : regionalProject.Regional_Project_Rollout__r) // all local rollouts of rollout converted into project
                    {
                       if(!isRegionalLeaderFound)
                        { 
                            localRollout.IPM_Regional_Rollout_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                            isRegionalLeaderFound = true;
                            localRollout.IPM_Project__c = regionalProject.IPM_Parent_Project__c;
                               
                        }
                        else
                        {
                            localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                            localRollout.IPM_Project__c = regionalProject.IPM_Parent_Project__c;
                              
                        }
                    
                        globalLocalRolloutMap.put(localRollout.id,localRollout); 
                       
                       // for local rollout in case of global view
                    
                        if(localRollout.Id.equals(sortedGlobalLocalRollout))
                        {
                               
                            localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                            //isLeaderFound = true;
                       }
                        else
                        {
                             localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                             
                        }                
                        
                         globalLocalRolloutMap.put(localRollout.id,localRollout);
                         
                    }
                 }
              } 
           }
        }
    
       if(!globalLocalRolloutMap.isEmpty())
       {
           update globalLocalRolloutMap.values();
           
       }
     } 
    
    
    
    
  }
}