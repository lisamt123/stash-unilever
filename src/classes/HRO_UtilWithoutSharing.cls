/**********************************************************************
 Name:  HRO_BoardingAction_CX()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
-------                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        dd/mm/yyyy      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/


public without sharing class HRO_UtilWithoutSharing {
	public HRO_UtilWithoutSharing() {
		
	}

	/**
	 * { function_description }
	 *
	 * @param      leaderTasks  { parameter_description }
	 * @param      managerId    { parameter_description }
	 */

	public static void addAccessForManager(List<HRO_Onboarding_Task__c> leaderTasks,Id managerId){
		system.debug('*** HRO addAccessForManager entry @leaderTasks :'+leaderTasks + '; for @managerId :'+managerId);
        List<HRO_Onboarding_Task__Share> sharingsForManager = new List<HRO_Onboarding_Task__Share>();

        for(HRO_Onboarding_Task__c leaderTask : leaderTasks){
            HRO_Onboarding_Task__Share managerShare = new HRO_Onboarding_Task__Share();
            managerShare.ParentID = leaderTask.id;
            managerShare.UserOrGroupId = managerId;
            managerShare.AccessLevel = 'Read';
            managerShare.RowCause = Schema.HRO_Onboarding_Task__Share.RowCause.Leader_Manager__c;
            sharingsForManager.add(managerShare);
        }
        system.debug('*** HRO addAccessForManager exit following sharing rules will be added:'+sharingsForManager);
        insert sharingsForManager;

    }

    /**
     * { function_description }
     *
     * @param      userId  { parameter_description }
     */
    @future 
    public static void addLeaderAccessToHROApplication(Id userId){
    	system.debug('****HRO addLeaderAccessToHROApplication entry for @userId:'+userId);
    	Id hroLeader = [Select id From PermissionSet Where name =: HRO_NavMenu_CC.HRNEWLEADER Limit 1].get(0).Id;
    	PermissionSetAssignment leaderAssigment = new PermissionSetAssignment();
    	leaderAssigment.AssigneeId = userId;
    	leaderAssigment.PermissionSetId = hroLeader;
    	system.debug('****HRO addLeaderAccessToHROApplication exit following persmisionSetAssigment will be added:'+leaderAssigment);
    	try{
    		insert leaderAssigment;
    	}catch(DmlException ex){
    		system.debug('such pesmisoon already exist: '+ex.getMessage());
    	}
    	
    	
    }

    /**
     * { function_description }
     *
     * @param      userId  { parameter_description }
     */
    @future 
    public static void addMangerAccessToHROApplication(Id userId){
    	system.debug('****HRO addLeaderAccessToHROApplication entry for @userId:'+userId);
    	Id hroManager = [Select id From PermissionSet Where name =: HRO_NavMenu_CC.HRMANAGER Limit 1].get(0).Id;
    	PermissionSetAssignment leaderAssigment = new PermissionSetAssignment();
    	leaderAssigment.AssigneeId = userId;
    	leaderAssigment.PermissionSetId = hroManager;
    	system.debug('****HRO addLeaderAccessToHROApplication exit following persmisionSetAssigment will be added:'+leaderAssigment);
    	try{
    		insert leaderAssigment;
    	}catch(DmlException ex){
    		system.debug('such pesmisoon already exist: '+ex.getMessage());
    	}
    	
    	
    }
}