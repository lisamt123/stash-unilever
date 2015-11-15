@isTest
public class IPM_Updateduedate_Trigger_Test{

public static IPM_Project__c projects;
public static IPM_Task__c task;

static void initializeData(){

        projects=new IPM_Project__c();
        projects.Name='teest';
        projects.IPM_Project_Name__c='test';
        projects.IPM_PM_Approach__c='Internal';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        insert projects;  
        
        task=new IPM_Task__c();
        //task.IPM_Task_Type='Negotiable';
        //task.IPM_Phase__c='Feasibility';
        insert task; 

}


public static testMethod void updateduedateTest(){

Test.startTest();
initializeData();
PageReference pRef = new PageReference('apex/IPM_Updateduedate?id='+task.ID);    
Test.setCurrentPage(pRef);
System.assert(projects.Id != NULL);
System.assert(task.Id != NULL);
Test.stopTest();


}

}