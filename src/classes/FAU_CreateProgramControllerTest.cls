@isTest(seeAllData = false)
private class FAU_CreateProgramControllerTest {

    private static testMethod void ContinueProcessTest(){
        FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
        insert program;
        ApexPages.currentPage().getParameters().put('id', program.id); 
        FAU_CreateProgramController controller = new FAU_CreateProgramController(new ApexPages.StandardController(program));
        System.assert(controller.ContinueProcess()!=null);
    }
    
}