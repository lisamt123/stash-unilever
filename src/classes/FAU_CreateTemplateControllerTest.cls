@isTest(seeAllData = true)
private class FAU_CreateTemplateControllerTest {

	private static testMethod void ContinueProcessTest(){
		FAU_Program__c program = FAU_TestUtil.buildProgram('Test Program', Date.today(), 'Test Location');
        insert program;
		ApexPages.currentPage().getParameters().put('id', program.id); 
		FAU_CreateTemplateController controller = new FAU_CreateTemplateController(new ApexPages.StandardController(program));
		System.assert(controller.ContinueProcess()!=null);
	}

}