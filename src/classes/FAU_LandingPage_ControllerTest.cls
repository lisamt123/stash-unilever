@isTest
private class FAU_LandingPage_ControllerTest {

    static testMethod void controllerTest() {
        
        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

        Date startDateFixture = Date.newInstance(2015, 10, 25);
        String locationFixture = 'Singapore';
        String inviteStateFixture = '';

        FAU_Participant__c participantRecord
             = FAU_TestUtil.createParticipantFixture(user, startDateFixture, locationFixture, inviteStateFixture);
        
        Test.startTest(); 
        
       // FAU_LandingPage_Controller controller = new FAU_LandingPage_Controller(new ApexPages.StandardController(participantRecord));
        
        Test.stopTest();
    }
}