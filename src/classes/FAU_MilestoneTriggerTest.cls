@isTest
private class FAU_MilestoneTriggerTest {

    static testMethod void createMilestonesParticipantTest() {
        FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
        insert program;
       // FAU_Webinar__c webinar =  FAU_TestUtil.createWebinar(program);
        FAU_Milestone__c milestone =  FAU_TestUtil.createMilestone(program);
        program.FAU_Status__c = 'Active';
        update program;
        FAU_Participant__c participant = FAU_TestUtil.buildParticipant(null, 'Test State', program);
        insert participant;
        milestone =  FAU_TestUtil.createMilestone(program);
        FAU_Milestone_Participant__c wpart = [select id from FAU_Milestone_Participant__c where FAU_Participant__c =: participant.id and FAU_Milestone__c=:milestone.id limit 1];
        update milestone;
        System.assert(wpart != null);
    }
}