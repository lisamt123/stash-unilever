@isTest

public class IPM_CreateLocalProjects_Test{

public static IPM_Project__c projects,project1,project2; 

public static void initializeData(){

        projects=new IPM_Project__c();
        projects.Name='teest';
        projects.IPM_Project_Name__c='test';
        projects.IPM_PM_Approach__c='Internal';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        insert projects;   
        
        project1=new IPM_Project__c();
        project1.Name='teest1';
        project1.IPM_Parent_Project__c=projects.Id;
        project1.IPM_Project_Name__c='test1';
        project1.IPM_PM_Approach__c='Internal';
        project1.IPM_IsCompleted__c=true;
        project1.IPM_Phase__c='Ideas';
        project1.IPMProject_Span__c = 'Regional';
        project1.IPM_Complexity__c='Lite';
        project1.IPM_Project_Leader__c=UserInfo.getUserId();
        insert project1; 
        
        project2=new IPM_Project__c();
        project2.Name='teest2';
        project2.IPM_Parent_Project__c=project1.Id;
        project2.IPM_Project_Name__c='test2';
        project2.IPM_PM_Approach__c='Internal';
        project2.IPM_IsCompleted__c=true;
        project2.IPM_Phase__c='Ideas';
        project2.IPM_Complexity__c='Lite';
        project2.IPM_Project_Leader__c=UserInfo.getUserId();
        insert project2; 
        
        }
        
   public static testMethod void createProjectsTest(){
   
   
   Test.startTest();
   initializeData();
   
   Set<Id> projectIds = new Set<Id>();
   projectIds.add(projects.Id);
   projectIds.add(project1.Id);
   
   Set<Id> regionalProjectIds= new Set<Id>();
   regionalProjectIds.add(project2.Id);
   
   IPM_CreateLocalProjects.createProjects(regionalProjectIds,projectIds);
   Test.stopTest();
   
   }

}