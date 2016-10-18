/**********************************************************************
 Name:  FAU_Participant_BioControllerExtTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_Participant_BioControllerExt                                                 
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_Participant_BioControllerExtTest
{
    public static string profileTest='Test';//Modified by Yugandhar
    private static final String LANDING_PAGE = '/apex/fau_landingpage?Id=';
    @isTest
    static void testSaveModule()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        participantRecord.FAU_Biography__c = profileTest;
        participantRecord.FAU_Unilever_Career__c = profileTest;
        participantRecord.FAU_Prior_Career__c = profileTest;
        participantRecord.FAU_Education__c = profileTest;
        participantRecord.FAU_Personal__c = profileTest;
        

        PageReference pageReference = Page.FAU_Participant_Bio;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_PArticipant_BioControllerExtension controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_PArticipant_BioControllerExtension(standardController);
            controller.submitBio();
        }
        Test.stopTest();
         
        System.assertEquals(LANDING_PAGE + participantRecord.Id, controller.submitBio().getUrl());
    }

    @isTest
    static void testCancelModule()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        participantRecord.FAU_Biography__c = profileTest;
        
        PageReference pageReference = Page.FAU_Participant_Bio;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_PArticipant_BioControllerExtension controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_PArticipant_BioControllerExtension(standardController);
            controller.cancelBio();
        }
        Test.stopTest();

        System.assertEquals(null ,[Select Id, FAU_Biography__c FROM FAU_Participant__c Where Id =:participantRecord.Id LIMIT 1].FAU_Biography__c);
        System.assertEquals(LANDING_PAGE + participantRecord.Id, controller.cancelBio().getUrl());
    }
}