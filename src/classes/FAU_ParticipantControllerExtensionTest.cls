/**********************************************************************
 Name:  FAU_ParticipantControllerExtensionTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_ParticipantControllerExtension                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_ParticipantControllerExtensionTest
{


    @isTest
    static void testInviteWhenNew()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'New';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_ParticipantControllerExtension(standardController);
        }
        Test.stopTest();

        System.assertEquals('Program could not be found for Participant, try clicking on the link again', ApexPages.GetMessages().get(0).getSummary());
  
    }



    @isTest
    static void testInvitedState()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        System.runAs(user)
        {
            controller = new FAU_ParticipantControllerExtension(standardController);
        }
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Initial');
    }


    @isTest
    static void testProceedWithInvitation()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

      FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            controller.proceedWithInvitation();
       // }
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Proceeding');
    }


    @isTest
    static void testAccept()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            controller.acceptInvite();
        //}
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Accepted');
    }


    @isTest
    static void testSelfFill()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            controller.selfFill();
        //}
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Registering');
    }


    @isTest
    static void testDecline()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        participantRecord.FAU_Decline_Reason__c = 'Other';

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            controller.declineReasonAvailable = true;
            controller.declineInvite();
        //}
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Declined');
    }

    @isTest
    static void testDeferToPa()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            controller.deferToPA();
        //}
        Test.stopTest();

        System.assertEquals('WithPA', controller.pageState);
    }


    @isTest
    static void testWebinars()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Invited';

        Account a = new Account(Name = 'Test Account ');
        insert a;
        Contact c = new Contact(firstname='Test',lastname='Test',AccountId=a.Id, email='fautestcontact@unilever.com');
        insert c;


        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
            List<FAU_Webinar_Participant__c> webinars = controller.webinars;
            System.assertEquals(2, webinars.size());
            List<String> webinarIds = new List<String>();
            webinarIds.add(webinars[0].Id);
            List<SelectOption> options = controller.webinarOptions;
            controller.selectedWebinar = webinars[1].Id;
            controller.selectedWebinars = webinarIds;
            controller.acceptInvite();
        //}
        Test.stopTest();

        System.assertEquals(2, webinars.size());
        System.assertEquals(2, controller.webinarOptions.size());
        System.assertEquals(2, controller.selectedWebinars.size());
    }



    @isTest
    static void testAlreadyAccepted()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Accepted';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
        //}
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Accepted');
    }


    @isTest
    static void testAlreadyDeclined()
    {
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = 'Declined';

        FAU_Participant__c participantRecord
             = createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        PageReference pageReference = Page.FAU_Participant_Register;
        Test.setCurrentPage(pageReference);

        ApexPages.StandardController standardController
             = new ApexPages.StandardController(participantRecord);

        FAU_ParticipantControllerExtension controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
            controller = new FAU_ParticipantControllerExtension(standardController);
        //}
        Test.stopTest();

        System.assertEquals(controller.pageState, 'Declined');
    }



    static private FAU_Participant__c createParticipantFixture(User user, Date startDate, String location, String inviteState)
    {
        return FAU_TestUtil.createParticipantFixture(user, startDate, location, inviteState);
    }


  
}