@isTest
private class IPM_CreateProject_Test {

    static testMethod void testCreateProjectConstructor(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        
        testData.testRunAs();        
        
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        IPM_CreateProject ipmCreateProject = new IPM_CreateProject();
        Test.stopTest();  
    
    }


    static testMethod void testCreateProjectId(){
        Test.startTest();
        IPM_CreateProject ipmCreateProject = new IPM_CreateProject();
        ipmCreateProject.CreateProjectId();
        Test.stopTest();  
        
    
    }



}