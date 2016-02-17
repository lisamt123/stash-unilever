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
	static void shouldGetlstSubCat(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            List<String> result = Oblix_Utils.getlstSubCat();
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
	static void shouldLstSubCatPerRecT(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            List<String> result = Oblix_Utils.lstSubCatPerRecT(Label.Oblix_Lbl_UIUX_AudioVisuel);
            System.assert(!result.isEmpty());
            List<String> result2 = Oblix_Utils.lstSubCatPerRecT(Label.Oblix_Lbl_UIUX_Digital);
            System.assert(!result2.isEmpty());
            List<String> result3 = Oblix_Utils.lstSubCatPerRecT(Label.Oblix_Lbl_UIUX_Experiential);
            System.assert(!result3.isEmpty());
            List<String> result4 = Oblix_Utils.lstSubCatPerRecT(Label.Oblix_Lbl_UIUX_Static_Img);
            System.assert(!result4.isEmpty());
            List<String> result5 = Oblix_Utils.lstSubCatPerRecT(Label.Oblix_Lbl_UIUX_Stimulus_Materials);
            System.assert(!result5.isEmpty());
            
            
            
            Test.stopTest();
        }
	}
	
	@isTest 
	static void shouldGetStageList(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            List<String> result = Oblix_Utils.getStageList();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}
	
	@isTest 
	static void shouldGetMapSubCategOption(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, list<string>> result = Oblix_Utils.getMapSubCategOption();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}
	
	@isTest 
	static void shouldGetmapSubCategOptionDescription(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getmapSubCategOptionDescription();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
	
	@isTest 
	static void shouldGetmapSubCategOptionDefinition(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getmapSubCategOptionDefinition();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
	
	@isTest 
	static void shouldGetProjectedItems2(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	list<string> stages = Oblix_Utils.getStageList();
            Test.startTest();
            String result = Oblix_Utils.getProjectedItems2(stages.get(0));
            Test.stopTest();
            System.assert(result.length()>1);
        }
	}	
	
	@isTest 
	static void shouldGetCompletedItems2(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	list<string> stages = Oblix_Utils.getStageList();
            Test.startTest();
            String result = Oblix_Utils.getCompletedItems2(stages.get(0));
            Test.stopTest();
            System.assert(result.length()>1);
        }
	}	
	
	@isTest 
	static void shouldGetSelectedStageCheckbox(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	list<string> stages = Oblix_Utils.getStageList();
            Test.startTest();
            String result = Oblix_Utils.getSelectedStageCheckbox(stages.get(0),stages.get(1));
            Test.stopTest();
            System.assert(result.length()>1);
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
	static void shouldGetMapRecordTypeDescription(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getMapRecordTypeDescription();
            Test.stopTest();
            System.assert(!result.isEmpty());
        }
	}	
	
	@isTest 
	static void shouldGetFeePercentages(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            list<string> lstStage = new list<String>{'1','2','3','4','5'};
            map<string, integer> result = Oblix_Utils.getFeePercentages(lstStage);
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
	static void shouldGetMapRTforSubCat(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            map<string, string> result = Oblix_Utils.getMapRTforSubCat();
            Test.stopTest();
            System.assert(!result.isEmpty());
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