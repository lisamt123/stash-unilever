/**********************************************************************
 Name:  HRO_BoardingAction_CX()
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

	public static String PREBOARDINGPHASE = 'Pre-Boarding';
    public static String DAY1PHASE = 'Day 1';
    public static String WEEK1PHASE = 'Week 1';
    public static String MONTH1PHASE = 'Month 1';
    public static String MONTH2PHASE = 'Month 2';
    public static String MONTH3PHASE = 'Month 3';
    public static String BEONBOARDPHASE = 'Beyond Onboarding';
    public static String MANAGERTASKTYPE = 'Manger';
    public static String NEWLEADERTASKTYPE = 'New Leader';
	

	public HRO_UnitTestFactory(){}
	/**
	 * createOnboardingTaskTemplate
	 *
	 * @param      taskFor   { Manger/Leader }
	 * @param      dueDate   { Number of days }
	 * @param      phase     { taks phase }
	 * @param      link      { task attached link }
	 * @param      taskType  { one of following :  }
	 */
	public static HRO_Onboarding_Plan__c createOnboardingTaskTemplate(String taskFor, Integer dueDate, String phase,String link, String taskType){

		HRO_Onboarding_Plan__c taskTemplate = new HRO_Onboarding_Plan__c();
		taskTemplate.Task_for__c = taskFor;
		taskTemplate.Due__c = dueDate;
		taskTemplate.Phase__c = phase;
		taskTemplate.Link__c = link;
		taskTemplate.Task_type__c = taskType;
		taskTemplate.Task_Description__c ='sample test descritption';

		return taskTemplate;
	}

	/**
	 * createDefaultSetOfOnboardingTasks {helper method to create task templates}
	 *
	 * @param      isManager  { template task assigned to manager or leader }
	 */

	public static List<HRO_Onboarding_Plan__c> createDefaultSetOfOnboardingTasks(Boolean isManager){
		List<HRO_Onboarding_Plan__c> taskTemplates = new List<HRO_Onboarding_Plan__c>();
		Schema.DescribeFieldResult phaseDescribe = HRO_Onboarding_Plan__c.Phase__c.getDescribe();
		Schema.DescribeFieldResult taskTypeeDescribe = HRO_Onboarding_Plan__c.Task_type__c.getDescribe();

		for(Schema.PicklistEntry phaseEntry : phaseDescribe.getPicklistValues()){
            String currentPhase = phaseEntry.getValue();
			for(Schema.PicklistEntry typeEntry : taskTypeeDescribe.getPicklistValues()){
				String currentTaskType = typeEntry.getValue();
				//do not create pre boarding task for leaders only for managers
				if(currentPhase == PREBOARDINGPHASE){
					if(isManager){
						taskTemplates.add(createOnboardingTaskTemplate(MANAGERTASKTYPE,calculateDueDateForTemplateTask(currentPhase),currentPhase,'www.test.com',currentTaskType));
					}
					continue;
				}

				if(isManager){
					taskTemplates.add(createOnboardingTaskTemplate(MANAGERTASKTYPE,calculateDueDateForTemplateTask(currentPhase),currentPhase,'www.test.com',currentTaskType));
				}else{
					taskTemplates.add(createOnboardingTaskTemplate(NEWLEADERTASKTYPE,calculateDueDateForTemplateTask(currentPhase),currentPhase,'www.test.com',currentTaskType));
				}
				
			}
		}

		return taskTemplates;
	}

	/**
	 * { Setting default Due Date for each phase }
	 *
	 * @param      phase  { parameter_description }
	 *
	 * @return     { description_of_the_return_value }
	 */
	public static Integer calculateDueDateForTemplateTask(String phase){
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

	public static User createUserManager(String Name){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName=Name, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test'+Name+'@testorg.com');
        insert u;
        HRO_UtilWithoutSharing.addMangerAccessToHROApplication(u.id);
        return u;	
	}

	public static User createUser(String Name){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'stand1', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName=Name, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test'+Name+'@testorg.com');

        insert u;
   
        return u;	
	}
}