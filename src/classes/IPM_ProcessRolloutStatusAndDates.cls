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
    
    private static Set<Id> globalMinimumSet = new Set<Id>();
    private static Set<Id> regionalMinimumSet = new Set<Id>();
    private static Map<Id,IPM_Project_Rollout__c> updatedRolloutStatusMap = new Map<Id,IPM_Project_Rollout__c>();       

    public static void execute(Set<Id> setTopLevelProjectIds,Set<Id> deleteRolloutIds)
    {
    	globalMinimumSet = new Set<Id>();
    	regionalMinimumSet = new Set<Id>();
    	updatedRolloutStatusMap = new Map<Id,IPM_Project_Rollout__c>();  
    	
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
      	Map<Id,Date> projectToTargetTLDMap = new Map<Id,Date>();
       
        if(!setTopLevelProjectIds.isEmpty())
     	{
            List<IPM_Project__c> lstGlobalProjects = [SELECT Id,IPM_Parent_Project__c,IPMProject_Span__c, IPM_Project_Rollout__c,Rollout_Plan_Target_Launch_Date__c,

                                                        // LOCAL ROLLOUT RELATED TO GLOBAL ORIGINAL 
                                                        (SELECT Id, Name, Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                            FROM IPM_Project_Rollout__r 
                                                            WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds ORDER By Target_Launch_Date__c),
                                                            
                                                        // LOCAL ROLLOUT IF IT IS REGIONAL ORIGINAL 
                                                        (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                            FROM Regional_Project_Rollout__r 
                                                            WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds order By Target_Launch_Date__c),
                                                            
                                                        (SELECT Id,Rollout_Plan_Target_Launch_Date__c FROM IPM_Projects__r)
                                                      FROM IPM_Project__c 
                                                      WHERE Id IN: setTopLevelProjectIds and Is_Archieved__c = false LIMIT 50000];

           	List<IPM_Project__c> regionalProjectList = new List<IPM_Project__c>();
           
           	// Sets the First Follower for Top Level Project View.
           	for(IPM_Project__c globalProject : lstGlobalProjects)
           	{
                IPM_Project_Rollout__c minimumdateRollout = null;
                if(globalProject.IPM_Project_Rollout__r!= null && !globalProject.IPM_Project_Rollout__r.isEmpty())
                {
                    minimumdateRollout = globalProject.IPM_Project_Rollout__r[0];
                    projectToTargetTLDMap.put(globalProject.id,minimumdateRollout.Target_Launch_Date__c);
                    regionalProjectList.addAll(globalProject.IPM_Projects__r);
                }
                else if(globalProject.Regional_Project_Rollout__r!= null && !globalProject.Regional_Project_Rollout__r.isEmpty())
                {
                    minimumdateRollout = globalProject.Regional_Project_Rollout__r[0];
                    projectToTargetTLDMap.put(globalProject.id,minimumdateRollout.Target_Launch_Date__c);
                } 
                
                if (minimumdateRollout != null)
                {
                	// Set the date for Regional Original Project
                    if(globalProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                    {
                    	regionalMinimumSet.add(minimumdateRollout.Id);
                    }
                    else
                    {
                    	//Set the date for Global Original Project
                    	globalMinimumSet.add(minimumdateRollout.Id);
                    }
                }    
           	}

           	Map<Id,IPM_Project__c> regionalProjectMap = new Map<Id,IPM_Project__c>();
           	
           	if(!regionalProjectList.isEmpty())
           	{
                List<IPM_Project__c> lstRegionalProjects = [SELECT Id, IPM_Project_Rollout__c,Rollout_Plan_Target_Launch_Date__c, 
                                                            (SELECT Id, Name,IPM_Project__c,Target_Launch_Date__c, IPM_Status__c,IPM_Regional_Rollout_Status__c,
                                                                Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                                FROM Regional_Project_Rollout__r 
                                                                WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND isActive__c = true AND id not in :deleteRolloutIds  
                                                                order By Target_Launch_Date__c) 
                                                            FROM IPM_Project__c 
                                                            WHERE Id IN: regionalProjectList and Is_Archieved__c = false LIMIT 50000];
                
                // Sets the First Follower for Intermediate Level Project View.
                for(IPM_Project__c regionalProject : lstRegionalProjects)
                {
                	IPM_Project_Rollout__c minimumdateRollout = null;
	                
	                if(regionalProject.Regional_Project_Rollout__r!= null && !regionalProject.Regional_Project_Rollout__r.isEmpty())
	                {
	                    minimumdateRollout = regionalProject.Regional_Project_Rollout__r[0];
	                    
	                    if(updatedRolloutStatusMap.containsKey(minimumdateRollout.Id))
	                    {
	                        minimumdateRollout = updatedRolloutStatusMap.get(minimumdateRollout.Id);
	                    }
	                    
	                    regionalMinimumSet.add(minimumdateRollout.Id);
	                    projectToTargetTLDMap.put(regionalProject.id,minimumdateRollout.Target_Launch_Date__c);
	                } 
	           	}
            	regionalProjectMap = new Map<Id,IPM_Project__c>(lstRegionalProjects);
           	}
           
           	populateRolloutStatus(lstGlobalProjects);
           	
           	List<IPM_Project__c> updatedParentProjectTLDList = processTLDDatesOnParentProject(projectToTargetTLDMap);
     		
     		// Update Rollout Status based on Local Rollouts TLD's
	  	if(!updatedRolloutStatusMap.isEmpty())
	        {
	            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;     
	            update updatedRolloutStatusMap.values();
	            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
	        }

		// Update Parent Projects TLD's, Milestone TLD's and Parent Rollouts TLD's based on Local Rollouts TLD's
		if(!updatedParentProjectTLDList.isEmpty())
            {
            	IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                
                //updating TLD for parent projects while skipping the trigger
                update updatedParentProjectTLDList; 
                
     			// Update Parent Rollouts TLD as well to Keep Project and corresponding Rollout TLDs in Sync.
                updateParentRolloutTLD(projectToTargetTLDMap.keySet());
                
                //To sync the Launch Date in Milestone based on TLD of project.
                // Since it is an explicit update of Parent Project's TLD, we need to sync milestones as well, hence the invocation,given project trigger logic is skipped.
                updatedMilestoneTLD(projectToTargetTLDMap.keyset());
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
                IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
            }
     	}
    }

    public static void updateParentRolloutTLD(Set<Id> parentProjectIdSet)
    {
    	Map<Id,IPM_Project__c> tempProjectMap = new Map<Id,IPM_Project__c>();
    	// get the latest TLD Date from project.
    	Map<Id,IPM_Project__c> parentProjectsMap = new Map<Id,IPM_Project__c>([SELECT Id, IPM_Project_Rollout__c, Rollout_Plan_Target_Launch_Date__c FROM IPM_Project__c 
    												WHERE Id IN: parentProjectIdSet and IPM_Project_Rollout__c != null AND Is_Archieved__c = false LIMIT 50000]);
                                                            
        updateTLDOnRollout(parentProjectsMap);
    }
    
    public static List<IPM_Project__c>  processTLDDatesOnParentProject(Map<Id,Date>  projectToTargetTLDMap)
    {
    	List<IPM_Project__c> updatedParentProjectTLDList = new List<IPM_Project__c>();
		for(Id projectId : projectToTargetTLDMap.keyset())
       	{
       		Date TLD = projectToTargetTLDMap.get(projectId);
       		IPM_Project__c project = new IPM_Project__c(Id=projectId, IPM_Target_Launch_Dates__c=TLD,Rollout_Plan_Target_Launch_Date__c=TLD);
       		updatedParentProjectTLDList.add(project);
       	}
       	return updatedParentProjectTLDList;
    }
    
    public static void populateRolloutStatus(List<IPM_Project__c> lstGlobalProjects)
    {
		for(IPM_Project__c globalProject : lstGlobalProjects)
       	{
            List<IPM_Project_Rollout__c> relatedLocalRollout = new List<IPM_Project_Rollout__c>();
            
            // Get the Related Local Rollouts.
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
            	// If Global Set contains this rollout, Set the Flag for Global View.
                if(globalMinimumSet.contains(localRollout.Id))
                {
                    localRollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
                }
                else
                {
                    localRollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                }
                
                // If Global Set contains this rollout, Set the Flag for regional View.
                if(regionalMinimumSet.contains(localRollout.Id))
                {
                    localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
                }
                else
                {
                    localRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;   
                }
                
                updatedRolloutStatusMap.put(localRollout.Id,localRollout);
            }
       	}
    }

    public static void updateTLDOnRollout(Map<Id,IPM_Project__c> projectMap)
    {
    	Map<Id, IPM_Project_Rollout__c> rolloutMap = new Map<Id, IPM_Project_Rollout__c>();
    	Date TLD = null; 
    	for(IPM_Project__c project : projectMap.values())
    	{
    		if(project.Rollout_Plan_Target_Launch_Date__c!=null)
    		{
    			TLD = project.Rollout_Plan_Target_Launch_Date__c;
    		}
    		else
    		{
    			TLD = project.IPM_Target_Launch_Dates__c;
    		}
    		
    		if(project.IPM_Project_Rollout__c !=null)
    		{
        		IPM_Project_Rollout__c rollout = new IPM_Project_Rollout__c(id = project.IPM_Project_Rollout__c, Target_Launch_Date__c=TLD);
        		rolloutMap.put(rollout.id, rollout);
    		}
    	}
    	update rolloutMap.values();
    }
    
    /*******************************************************************************************************
    * @description  Method to update TLD on milestone
    * @param        List IPM_Project
    * @return       NONE
    */
    public static void updatedMilestoneTLD( Set<Id> projectIdSet) 
    {
        List<IPM_Milestone__c> updatedMilestoneList = new List<IPM_Milestone__c> {};
        for(IPM_Milestone__c ipmMileStone :[Select Id, IPM_Name__c, IPM_Due_Date__c, IPM_Planned_Date__c, IPM_Project__c, IPM_Project__r.IPM_Target_Launch_Dates__c from IPM_Milestone__c where IPM_Project__c =: projectIdSet])
        {
            ipmMileStone.IPM_Project_Launch_Date__c = ipmMileStone.IPM_Project__r.IPM_Target_Launch_Dates__c;
            
            if(IPM_Utils.TargetLaunchDateShiptoTrade.equals(ipmMileStone.IPM_Name__c) || IPM_ConstantUtils.SHIPTO_TRADE_TLD.equals(ipmMileStone.IPM_Name__c)) 
            {
            	ipmMileStone.IPM_Planned_Date__c = ipmMileStone.IPM_Project__r.IPM_Target_Launch_Dates__c;
            }
            updatedMilestoneList.add(ipmMileStone);
        }
        if(!updatedMilestoneList.isEmpty())
        {
            update updatedMilestoneList;
        }
    }
}