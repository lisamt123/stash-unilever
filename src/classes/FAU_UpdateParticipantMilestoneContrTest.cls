@isTest
private class FAU_UpdateParticipantMilestoneContrTest {

	private static String PROFILE_PARTICIPANT_HOLDS = 'System Administrator';

    static testMethod void classTest() {
    	
    	Profile pp = [select id from Profile where name ='System Administrator'];
        User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa16688@dfg.com', 
                Email='vanessa@dfg.com', Alias='dfg16688', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
                LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        
        insert u;   
    	
    	System.runAs(u){
    	
	    	User[] users = FAU_TestUtil.createUsersWithProfile(PROFILE_PARTICIPANT_HOLDS,1);
	
	        Date startDateFixture = Date.newInstance(2015, 10, 25);
	        String locationFixture = 'Singapore';
	        String inviteStateFixture = 'Invited';
	             
	        Test.startTest();
	
	        FAU_Participant__c participantRecord = FAU_TestUtil.createParticipantFixture(users.get(0), startDateFixture, locationFixture, inviteStateFixture);
	        
	        Test.stopTest();
	    	
	    	FAU_Milestone_Participant__c participantMilestone = [Select Id FROM FAU_Milestone_Participant__c WHERE FAU_Participant__c = :participantRecord.Id limit 1];
	
	        FAU_UpdateParticipantMilestoneController controller = new FAU_UpdateParticipantMilestoneController(new ApexPages.StandardController(participantMilestone));
	        
	        PageReference cancelActionResult = controller.doCancel();
	        System.assert(cancelActionResult.getUrl().contains('/apex/fau_landingpage?Id='));
	        
	        controller.milestoneCompletionType = 'Participant Update';
	        controller.completeStatus = false;
	        System.assert(!controller.validateCompletion().isEmpty());
	        
	        controller.milestoneCompletionType = 'Information Needed';
	        controller.participantDescription = '';
	        System.assert(!controller.validateCompletion().isEmpty());
	        
	        controller.milestoneCompletionType = 'File Needed';
	        System.assert(!controller.validateCompletion().isEmpty());
	        
	        Attachment attachment = new Attachment(ParentId = participantMilestone.id, name = 'testName', body = Blob.valueOf('testBody'));
	        controller.attachment = attachment;
	        controller.participantDescription = 'test';
	        controller.record = participantMilestone;
	        
	        System.assert(controller.doSave().getUrl().contains('/apex/fau_landingpage?Id='));
	        
	        controller.milestoneCompletionType = 'Participant Update';
	        
	        System.assert(controller.doSave() == null);
    	}
            
    }
    
}