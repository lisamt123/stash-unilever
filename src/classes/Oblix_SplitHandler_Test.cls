@isTest
public with sharing class Oblix_SplitHandler_Test {

    private static String buildErrorMessage(Database.Error[] errs){
        String errorMsg = '';
        // Operation failed, get all errors. What was the cause?                
        for(Database.Error err : errs){
           errorMsg +=  'Error: ' + err.getMessage() + '\n';
        }       
        return errorMsg;
    }

	@isTest static void Oblix_SplitHandler_Test(){

        insert Oblix_TestUtils.createOblixCustomSettings();
		User u = Oblix_TestUtils.createTestUser();
        
        System.runAs(u) {
            Test.startTest();

                MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

                Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

                Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
                
                List<Oblix_Marketing_SOW_Project_Splits__c> list_project_splits_to_insert = Oblix_TestUtils.createProjectSplits(project.id, 5);

                Database.SaveResult[] save_result;
                // insert with no errors
                save_result = Database.insert(list_project_splits_to_insert, false);
                Boolean has_error = false;
                String error_msg = '';

                for(Database.SaveResult ur : save_result){ 
                    if (!ur.isSuccess()){
                        has_error = true;
                        error_msg = buildErrorMessage(ur.getErrors());
                    }
                }

                System.assertEquals(false, has_error);

                delete list_project_splits_to_insert;

                // S.M. this is now handled in VF controllers instead of trigger handler

                //// cause error by inserting splits which dont add up to 100%
                //list_project_splits_to_insert = Oblix_TestUtils.createProjectSplits(project.id, 4);
                //list_project_splits_to_insert[0].Percentage__c = 10;

                //save_result = Database.insert(list_project_splits_to_insert, false);
                
                //has_error = false;
                //error_msg = '';

                //for(Database.SaveResult ur : save_result){ 
                //    if (!ur.isSuccess()){
                //        has_error = true;
                //        error_msg = buildErrorMessage(ur.getErrors());
                //    }
                //}

                //System.assertEquals(true, has_error);
                //System.assertEquals('Error: Total Percentage for this project is below 100%, please raise it' + '\n', error_msg);



            Test.stopTest();
        }
	}
}