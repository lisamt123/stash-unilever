/**********************************************************************
 Name:  HRO_UnitTestFactory()
 Copyright © 2015  Salesforce
======================================================
======================================================
Purpose:  Helper class to improve unit tests                                                          
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        dd/mm/yyyy      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_UnitTestFactory {

	public static final String PREBOARDINGPHASE = 'Pre-Boarding';
    public static final String DAY1PHASE = 'Day 1';
    public static final String WEEK1PHASE = 'Week 1';
    public static final String MONTH1PHASE = 'Month 1';
    public static final String MONTH2PHASE = 'Month 2';
    public static final String MONTH3PHASE = 'Month 3';
    public static final String BEONBOARDPHASE = 'Beyond Onboarding';
    public static final String MANAGERTASKTYPE = 'Manager';
    public static final String NEWLEADERTASKTYPE = 'New Leader';
	public static final String ENUS='en_US';
    private static final String HRADMIN = 'HRO_HRAdmin';
    private static final String HRMANAGER = 'HRO_HeadstartManager';

	private HRO_UnitTestFactory(){}
    
	/*******************************************************************
   Purpose:  Helper method for creating Onboarding Task Template                                                 
   Parameters: [String taskFor, Integer dueDate, String phase,String link, String taskType]
   Returns: [HRO_Onboarding_Plan__c]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static HRO_Onboarding_Plan__c createOnboardingTaskTemplate(String taskFor, Integer dueDate, String phase,String link, String taskType){
		system.debug('***HRO Entring createOnboardingTaskTemplate');
		HRO_Onboarding_Plan__c taskTemplate = new HRO_Onboarding_Plan__c();
		taskTemplate.Due__c = dueDate;
		taskTemplate.Phase__c = phase;
		taskTemplate.Link__c = link;
		taskTemplate.Task_type__c = taskType;
		//add Task_Description__c
		taskTemplate.Task_Description__c ='sample test descritption';
		system.debug('***HRO Exiting createOnboardingTaskTemplate'+taskTemplate);
		return taskTemplate;
	}

	/*******************************************************************
   Purpose:  Helper method for creating Onboarding Task Templates                                                 
   Parameters: [String taskFor, Integer dueDate, String phase,String link, String taskType]
   Returns: [List<HRO_Onboarding_Plan__c>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static List<HRO_Onboarding_Plan__c> createDefaultSetOfOnboardingTasks(Boolean isManager){
        system.debug('Enerig method createDefaultSetOfOnboardingTasks @isManager:'+isManager);
		List<HRO_Onboarding_Plan__c> taskTemplates = new List<HRO_Onboarding_Plan__c>();
		Schema.DescribeFieldResult phaseDescribe = HRO_Onboarding_Plan__c.Phase__c.getDescribe();
		Schema.DescribeFieldResult taskTypeeDescribe = HRO_Onboarding_Plan__c.Task_type__c.getDescribe();

		for(Schema.PicklistEntry phaseEntry : phaseDescribe.getPicklistValues()){
            
			for(Schema.PicklistEntry typeEntry : taskTypeeDescribe.getPicklistValues()){
				String currentTaskType = typeEntry.getValue();
				//do not create pre boarding task for leaders only for managers
				if(phaseEntry.getValue() == PREBOARDINGPHASE){
					if(isManager){
						taskTemplates.add(createOnboardingTaskTemplate(MANAGERTASKTYPE,calculateDueDateForTemplateTask(phaseEntry.getValue()),phaseEntry.getValue(),'www.test.com',currentTaskType));
					}
					continue;
				}

				if(isManager){
					taskTemplates.add(createOnboardingTaskTemplate(MANAGERTASKTYPE,calculateDueDateForTemplateTask(phaseEntry.getValue()),phaseEntry.getValue(),'www.test.com',currentTaskType));
				}else{
					taskTemplates.add(createOnboardingTaskTemplate(NEWLEADERTASKTYPE,calculateDueDateForTemplateTask(phaseEntry.getValue()),phaseEntry.getValue(),'www.test.com',currentTaskType));
				}
				
			}
		}
		system.debug('***HRO Exiting method createDefaultSetOfOnboardingTasks:'+JSON.serialize(taskTemplates));
		return taskTemplates;
	}
    
    /*******************************************************************
   Purpose:  Helper method for creating Onboarding Task for unit test perpouse                                 
   Parameters: [String taskFor, Integer dueDate, String phase,String link, String taskType]
   Returns: [List<HRO_Onboarding_Plan__c>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public static List<HRO_Onboarding_Task__c> createPreboardingTask(User manager,User leader,List<HRO_Onboarding_Plan__c> templates){
        
        system.debug('Enerig method createPreboardingTask @manager:'+manager+'@leader'+leader+' @templates:'+templates);
        List<HRO_Onboarding_Task__c> tasksToCreate = new List<HRO_Onboarding_Task__c>();
        HRO_Onboarding_Task_Set__c taskSet = new HRO_Onboarding_Task_Set__c();
        taskSet.New_Leader_Name__c = leader.LastName;
        taskSet.Start_Date__c = Date.today().addDays(-1);
        insert taskSet;
        for(HRO_Onboarding_Plan__c p : templates){
            //if(p.Phase__c == PREBOARDINGPHASE){
                HRO_Onboarding_Task__c managerTask = new HRO_Onboarding_Task__c();
                managerTask.Action_Type__c = p.Task_type__c;
                managerTask.Completed__c = false;
                managerTask.Due_Date__c = Date.today().addDays(Integer.valueOf(p.Due__c));
                //managerTask.OwnerId = UserInfo.getUserId();
                managerTask.New_Leader_Name__c = leader.LastName;
                managerTask.Onboarding_Task_Set__c=taskSet.id;
                //managerTask.Onboarding_Plan__c =  p.id;
                managerTask.Phase__c = p.Phase__c;
                managerTask.Task_Detail__c = p.Task_Description__c;
                managerTask.ExternalPortalLink__c = p.Link__c;
                
                tasksToCreate.add(managerTask);
            //}
        }
        
        insert tasksToCreate;
        system.debug('Exiting method createPreboardingTask :'+tasksToCreate);
        return tasksToCreate;
       // return tasksToCreate;
    }
    
    

	/*******************************************************************
   Purpose:  Helper method for calculating Due Dates for test tasks                           
   Parameters: [String]
   Returns: [Integer]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static Integer calculateDueDateForTemplateTask(String phase){
        system.debug('***HRO Entring calculateDueDateForTemplateTask @phase:'+phase);
		if(phase == PREBOARDINGPHASE){
			return 0;
		}else if(phase == DAY1PHASE){
			return 1;
		}else if(phase == WEEK1PHASE){
			return 7;
		}else if(phase == MONTH1PHASE){
			return 30;
		}else if(phase == MONTH2PHASE){
			return 60;
		}else if(phase == MONTH3PHASE){
			return 90;
		}else if(phase == BEONBOARDPHASE){
			return 95;
		}else{
			return 0;
		}
	}
	
    /*******************************************************************
   Purpose:  Helper method for creating user for manager                          
   Parameters: [String]
   Returns: [User]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static User createUserManager(String Name){
        system.debug('***HRO Entring createUserManager @Name:'+Name);
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName=Name, LanguageLocaleKey=ENUS, 
            LocaleSidKey=ENUS, ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test'+Name+'@testorg.com');
        insert u;
        system.debug('***HRO createUserManager createUser'+u);
        return u;	
	}
	
   /*******************************************************************
   Purpose:  Helper method for standard user                         
   Parameters: [String]
   Returns: [User]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static User createUser(String Name){
        system.debug('***HRO Entring createUser @Name:'+Name);
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'stand1', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName=Name, LanguageLocaleKey=ENUS, 
            LocaleSidKey=ENUS, ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test'+Name+'@testorg.com');

        insert u;
   		system.debug('***HRO Exiting createUser'+u);
        return u;	
	}
    
    /*******************************************************************
   Purpose:  Helper method for adding permission sets for manager and HR Admin                         
   Parameters: [User,Uset]
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	public static void addHROPermissions(User manager,User adminUser){
        system.debug('***HRO Entring addHROPermissions @manager:'+manager+'@adminUser:'+adminUser);
		List<PermissionSetAssignment> permissionsToAdd = new List<PermissionSetAssignment>();
        
        Id hroManager = [Select id From PermissionSet Where name =: HRMANAGER Limit 1].get(0).Id;
        Id hroAdminId = [Select id From PermissionSet Where name =: HRADMIN Limit 1].get(0).Id;
        PermissionSetAssignment permSetForAdmin = new PermissionSetAssignment(PermissionSetId = hroAdminId, AssigneeId = adminUser.id);
        permissionsToAdd.add(permSetForAdmin);
        PermissionSetAssignment permSetForManger = new PermissionSetAssignment(PermissionSetId = hroManager, AssigneeId = manager.id);
        permissionsToAdd.add(permSetForManger);
        insert permissionsToAdd;
        
   		system.debug('***HRO Exiting addHROPermissions');	
	}
}