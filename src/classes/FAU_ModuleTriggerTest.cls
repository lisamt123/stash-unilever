@isTest
private class FAU_ModuleTriggerTest {

    static testMethod void createModulesParticipantTest() {
       FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
       insert program;
       FAU_Webinar__c webinar =  FAU_TestUtil.createWebinar(program);
       FAU_Module__c module =  FAU_TestUtil.createModule(program);
       program.FAU_Status__c = 'Active';
       update program;
       FAU_Participant__c participant = FAU_TestUtil.buildParticipant(null, 'Test State', program);
       insert participant;
       module =  FAU_TestUtil.createModule(program);
       FAU_Module_Participant__c wpart = [select id from FAU_Module_Participant__c where FAU_Participant__c =: participant.id and FAU_Module__c=:module.id limit 1];
       System.assert(wpart != null);
    }
}