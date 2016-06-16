@isTest
private class Oblix_Utils_Test {

	@isTest(seeAllData=true) 
	static void shouldMapRecordType(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            Map<string, ID> result = Oblix_Utils.MapRecordType('Account');
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}
	
	
	@isTest 
	static void shouldGetAllFieldsInFieldsSet(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            List<String> result = Oblix_Utils.getAllFieldsInFieldsSet('Oblix_SOW_Projects__c', 'Oblix_Campaign_Summary');
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
		
	
	@isTest 
	static void shouldGetAbreViationByRTBySubCatgForCardAssets(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getAbreViationByRTBySubCatgForCardAssets();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
	
	@isTest 
	static void shouldGetAbreViationForCardAssets(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getAbreViationForCardAssets();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
	
	@isTest 
	static void shouldCountrryGetId(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            MDO_Geography__c g = new MDO_Geography__c(name='testname', geography_type__c = 'Country');
            insert g;
            Id result = Oblix_Utils.CountrryGetId('testname');
            Test.stopTest();
            System.assertEquals(g.Id,result);
        }
	}		
	
	@isTest 
	static void shouldSelectOptionSortByLabel(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            list<selectOption> selectOptionsToSort = new list<selectOption>();
            selectOptionsToSort.add(new selectOption('2','2'));
            selectOptionsToSort.add(new selectOption('3','3'));
            selectOptionsToSort.add(new selectOption('1','1'));
            list<selectOption> result = Oblix_Utils.selectOptionSortByLabel(selectOptionsToSort);
            Test.stopTest();
            System.assertEquals('1',result.get(0).getLabel());
            System.assertEquals('2',result.get(1).getLabel());
            System.assertEquals('3',result.get(2).getLabel());
        }
	}	
	
	@isTest 
	static void shouldSetFirstValue(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            list<selectOption> selectOptionsToSort = new list<selectOption>();
            selectOptionsToSort.add(new selectOption('2','2'));
            selectOptionsToSort.add(new selectOption('3','3'));
            selectOptionsToSort.add(new selectOption('1','1'));
            list<selectOption> result = Oblix_Utils.setFirstValue('first',selectOptionsToSort);
            Test.stopTest();
            System.assertEquals(4,result.size());

        }
	}	
	
	@isTest 
	static void shouldExitSwop(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            Pagereference  result = Oblix_Utils.exitSwop();
            Test.stopTest();
            System.assert(result!=null);

        }
	}	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}