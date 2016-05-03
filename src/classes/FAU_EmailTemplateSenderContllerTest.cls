/**********************************************************************
 Name:  FAU_EmailTemplateSenderContllerTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_EmailTemplateSenderController                                                  
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_EmailTemplateSenderContllerTest
{
      @isTest
    static void testSetupEmailSender()
    {
    	
    	FAU_Participant__c[] lParticipant =new FAU_Participant__c[]{}; 
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        /*for(Integer i = 100; i >=0 ; i--) { 
	        FAU_Participant__c anotherParticipantRecord = new FAU_Participant__c();
	        anotherParticipantRecord.FAU_Invite_State__c = participantRecord.FAU_Invite_State__c;
	        anotherParticipantRecord.FAU_Program_Wave__c = FAU_Program_Wave__c.Id;
	        anotherParticipantRecord.FAU_User__c = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS).Id;
	        lParticipant.add(anotherParticipantRecord);
	    }*/

	    lParticipant.add(ParticipantRecord);
        
        PageReference pageReference = Page.FAU_EmailTemplateSender;
        Test.setCurrentPage(pageReference);

		ApexPages.StandardSetController standardController = new ApexPages.StandardSetController(lParticipant); 

        FAU_EmailTemplateSenderController controller;

        Test.startTest(); 

        //System.runAs(user)
        //{
          controller = new FAU_EmailTemplateSenderController(standardController);


        //}
        Test.stopTest();

        System.assert(controller <> null, 'testSetupEmailSender : Controller ins Null');
  
    }



    @isTest
    static void testEmailSending()
    {
    	
    	FAU_Participant__c[] lParticipant =new FAU_Participant__c[]{}; 
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';


        Account a = new Account(Name = 'Test Account ');
        insert a;
		Contact c = new Contact(firstname='Test',lastname='Test',AccountId=a.Id, email='test@test.com');
        insert c;

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);

        /*for(Integer i = 100; i >=0 ; i--) { 
	        FAU_Participant__c anotherParticipantRecord = new FAU_Participant__c();
	        anotherParticipantRecord.FAU_Invite_State__c = participantRecord.FAU_Invite_State__c;
	        anotherParticipantRecord.FAU_Program_Wave__c = FAU_Program_Wave__c.Id;
	        anotherParticipantRecord.FAU_User__c = createUserWithProfile(PROFILE_PARTICIPANT_HOLDS).Id;
	        lParticipant.add(anotherParticipantRecord);
	    }*/

	    lParticipant.add(ParticipantRecord);
        
        PageReference pageReference = Page.FAU_EmailTemplateSender;
        Test.setCurrentPage(pageReference);

		ApexPages.StandardSetController standardController = new ApexPages.StandardSetController(lParticipant); 

        FAU_EmailTemplateSenderController controller = new FAU_EmailTemplateSenderController(standardController);

        Id EmailTemplateId = [select Id from EmailTemplate LIMIT 1].Id;

        Test.startTest(); 

        //System.runAs(user)
        //{	
        	List<SelectOption> temp = controller.getMyPersonalTemplateOptions();
        	controller.settemplate((String) EmailTemplateId);
        	//controller.setSelected(lParticipant);
        	String EmailTemplate = controller.gettemplate();
        	controller.sendEmails();

        //}
        Test.stopTest();

        System.assert(controller <> null, 'testSetupEmailSender : Controller ins Null');
  
    }



}