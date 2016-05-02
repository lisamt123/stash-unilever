@isTest
private class FAU_WebinarTriggerTest {

    static testMethod void createWebinarsParticipantTest() {
        FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
        insert program;
        FAU_Webinar__c webinar =  FAU_TestUtil.createWebinar(program);
        program.FAU_Status__c = 'Active';
        update program;
        FAU_Participant__c participant = FAU_TestUtil.buildParticipant(null, 'Test State', program);
        insert participant;
        webinar =  FAU_TestUtil.createWebinar(program);
        FAU_Webinar_Participant__c wpart = [select id from FAU_Webinar_Participant__c where FAU_Participant__c =: participant.id and FAU_Webinar__c=:webinar.id limit 1];
        System.assert(wpart != null);
    }
}