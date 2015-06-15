/**********************************************************************
 Name:  FAU_Module_Part_ControllerExtTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_Module_Part_ControllerExt                                                  
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_Module_Part_ControllerExtTest
{
    private static final String LANDING_PAGE = '/apex/fau_landingpage?Id='; 
      @isTest
    static void testIsLocalModule()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        FAU_Module_Participant__c moduleParticipantRecord = [select ID, FAU_Participant__c, FAU_Is_Local__c,FAU_Dietary_Restrictions__c,FAU_Dietary_Restrictions_Describe_Other__c from FAU_Module_Participant__c
                                                        WHERE FAU_Participant__c = :participantRecord.id LIMIT 1];

        PageReference pageReference = Page.FAU_ModuleParticipant;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(moduleParticipantRecord);

        FAU_Module_Part_ControllerExt controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_Module_Part_ControllerExt(standardController);
            controller.getIsLocal();
            controller.updateIsLocal();

        }
        Test.stopTest();

        System.assertEquals(controller.getIsLocal(), true);
  
    }

    @isTest
    static void testIsLocalFalseModule()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        FAU_Module_Participant__c moduleParticipantRecord = [select ID, FAU_Participant__c, FAU_Is_Local__c from FAU_Module_Participant__c
                                                        WHERE FAU_Participant__c = :participantRecord.id LIMIT 1];

        moduleParticipantRecord.FAU_Is_Local__c = false;
        update moduleParticipantRecord;

        PageReference pageReference = Page.FAU_ModuleParticipant;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(moduleParticipantRecord);

        FAU_Module_Part_ControllerExt controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_Module_Part_ControllerExt(standardController);
            controller.getIsLocal();
            controller.updateIsLocal();

        }
        Test.stopTest();

        System.assertEquals(controller.getIsLocal(), true);
    }

      @isTest
    static void testSaveModuleParticipant()
    {
        String nextPage= '';
        
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        FAU_Module_Participant__c moduleParticipantRecord = [select ID, FAU_Participant__c, FAU_Is_Local__c,FAU_Dietary_Restrictions__c,FAU_Dietary_Restrictions_Describe_Other__c from FAU_Module_Participant__c
                                                        WHERE FAU_Participant__c = :participantRecord.id LIMIT 1];

        PageReference pageReference = Page.FAU_ModuleParticipant;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(moduleParticipantRecord);

        FAU_Module_Part_ControllerExt controller;

        controller = new FAU_Module_Part_ControllerExt(standardController);



        Test.startTest(); 

        //System.runAs(user) Check why this is a problem with Dan; it doesn't happen on the front end
        //{ 
            nextPage= controller.submitMP().getUrl();       
        //}
        Test.stopTest();

        System.assertEquals(LANDING_PAGE + participantRecord.Id, nextPage);
       
    }


      @isTest
    static void testCancelModule()
    {
        String nextPage;
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        FAU_Module_Participant__c moduleParticipantRecord = [select ID, FAU_Participant__c, FAU_Is_Local__c from FAU_Module_Participant__c
                                                        WHERE FAU_Participant__c = :participantRecord.id LIMIT 1];

        PageReference pageReference = Page.FAU_ModuleParticipant;
        Test.setCurrentPage(pageReference);

        update moduleParticipantRecord;

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(moduleParticipantRecord);

        FAU_Module_Part_ControllerExt controller;

        controller = new FAU_Module_Part_ControllerExt(standardController);

        Test.startTest(); 

        System.runAs(user)
        {
            nextPage = controller.cancelMP().getUrl();  
            
        }
        Test.stopTest();

        System.assertEquals(LANDING_PAGE + participantRecord.Id, nextPage);
    }
}