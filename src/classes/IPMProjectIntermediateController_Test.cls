@isTest
private class IPMProjectIntermediateController_Test{

public static IPM_Project__c project;

static void initializeData(){

        project=new IPM_Project__c();
        project.Name='teest';
        project.IPM_Project_Name__c='test';
        project.IPM_PM_Approach__c='Internal';
        project.IPM_IsCompleted__c=true;
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Lite';
        project.IPM_Project_Leader__c=UserInfo.getUserId();
        insert project;  
        
        }

    static testMethod void testIPMProjectIntermediateController(){
        
        Test.startTest();
        initializeData();
        PageReference pRef = new PageReference('apex/IPMProjectIntermediateController?id='+project.Id);    
        Test.setCurrentPage(pRef);
        IPMProjectIntermediateController intController = new IPMProjectIntermediateController();
        intController.isImage=true;
        intController.isDescVisible=true;
        intController.projectType='true';
        Test.stopTest(); 
    
    }

}