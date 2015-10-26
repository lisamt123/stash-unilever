/**********************************************************************
 Name:  HRO_TaskLinkForwarder_CXTest()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test class for HRO_TaskLinkForwarder_CX
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        08/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/
@isTest

public with sharing class HRO_TaskLinkForwarder_CXTest {
    
   /*******************************************************************
   Purpose:  Testing method update record  
   Parameters: [optional]
   Returns: [optional]
   Throws [Exceptions]: [optional]                                                          
  ********************************************************************/	
    @isTest static void testUpdateAction() {
        User manager = HRO_UnitTestFactory.createUserManager('HROtestManager');
		User leader = HRO_UnitTestFactory.createUser('HROtestLeader');
        
        List<HRO_Onboarding_Plan__c> managerTasksTemplate = HRO_UnitTestFactory.createDefaultSetOfOnboardingTasks(true);
        
        List<HRO_Onboarding_Task__c> managerTasks =  HRO_UnitTestFactory.createPreboardingTask(manager,leader,managerTasksTemplate);
        PageReference pageRef = Page.HRO_TaskLinkForwarder;
        pageRef.getParameters().put('id',managerTasks.get(0).id);
        pageRef.getParameters().put('pageUrl',EncodingUtil.urlDecode('http:\\\\www.salesforce.com', 'UTF-8'));
        Test.setCurrentPage(pageRef);
        //test task with link
        
        Test.startTest();
        HRO_TaskLinkForwarder_CX pageController = new HRO_TaskLinkForwarder_CX(new ApexPages.StandardController(managerTasks[0]));
        PageReference pRef1 = pageController.updateActionTaken();
        //check if task mark as completed
        system.assertEquals(true, [Select Completed__c from HRO_Onboarding_Task__c WHERE ID =: managerTasks.get(0).id].get(0).Completed__c,'Task should be marked Completed');
        system.assertEquals('http:\\\\www.salesforce.com', pRef1.getUrl(),'System should redirect user to proper page');
        
        
        PageReference pageRef1 = Page.HRO_TaskLinkForwarder;
        pageRef1.getParameters().put('id',managerTasks.get(0).id);
        pageRef1.getParameters().put('selectedLeader',managerTasks.get(0).New_Leader_Name__c);
        Test.setCurrentPage(pageRef1);
        PageReference pRef2 = pageController.updateActionTaken();
        system.assert(pRef2.getUrl().contains('HRO_HeadStart'),'System should redirect user to headstart page');
        pageController.redirectToPage ='some page';
        Test.stopTest();
        
    }

}