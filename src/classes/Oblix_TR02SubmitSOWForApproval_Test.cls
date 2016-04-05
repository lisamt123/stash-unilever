//S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    //Replaced as part of code refactoring
@isTest 
private class Oblix_TR02SubmitSOWForApproval_Test {

    // static testMethod void testApprovalSuccess() {
        
    //         Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
    //     //Insert User 
    //     User manager= new User(Alias = 'manTest', Email='manageUser@unilever.com', 
    //      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
    //      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test manager', 
    //      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
    //      UserName='manager@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
    //     insert manager;
        
            
    //     //Insert User 
    //     User u= Oblix_TestUtils.createTestUser();
    //        u.ManagerId = manager.Id;
    //        update u;
    //     System.runAs(u){
    //        Test.startTest();
    //             Marketing_SOW__c marketingSow = new Marketing_SOW__c();
    //                marketingSow.Active__c = true;
    //                marketingSow.Name = 'Marketinf Sow Approval Test';
    //                marketingSow.SOW_Status__c = 'Draft - with Unilever';
    //                marketingSow.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
    //                insert marketingSow;
    //                marketingSow.SOW_Status__c = Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL;
    //                update marketingSow;

    //                // ensure that the opp was submitted for approval
    //                //List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :marketingSow.id];
    //                //System.assertEquals(processInstances.size(),1); 
    //        Test.stopTest();
    //            System.assertNotEquals(marketingSow,null);
    //     } 
    //}
}