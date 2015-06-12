@isTest
public class IPM_UpdateChildIpmProjects_Test{

    public static TestMethod void updchildprojects(){
         IPM_Project__c projects=new IPM_Project__c();
        projects.Name='teest';
        projects.IPM_Project_Name__c='test';
        projects.IPM_PM_Approach__c='Internal';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        projects.IPM_Target_Launch_Date__c='30-12-2016';
        insert projects;   
        
        IPM_Project__c project1=new IPM_Project__c();
        project1.Name='teest1';
        project1.IPM_Parent_Project__c=projects.Id;
        project1.IPM_Project_Name__c='test1';
        project1.IPM_PM_Approach__c='Internal';
        project1.IPM_IsCompleted__c=true;
        project1.IPM_Phase__c='Ideas';
        project1.IPM_Complexity__c='Lite';
        project1.IPM_Project_Leader__c=UserInfo.getUserId();
        project1.IPM_Target_Launch_Date__c='30-12-2016';
        insert project1; 
        
        IPM_Project__c project2=new IPM_Project__c();
        project2.Name='teest2';
        project2.IPM_Parent_Project__c=project1.Id;
        project2.IPM_Project_Name__c='test2';
        project2.IPM_PM_Approach__c='Internal';
        project2.IPM_IsCompleted__c=true;
        project2.IPM_Phase__c='Ideas';
        project2.IPM_Complexity__c='Lite';
        project2.IPM_Project_Leader__c=UserInfo.getUserId();
        insert project2; 
        
        
        test.startTest();
            projects.IPM_Fast_Track_Project__c=true;
            projects.IPMProject_Span__c='Global';
            update projects;
            
            project1.IPMProject_Span__c='Global';
            update project1;
            project2.IPMProject_Span__c='Regional';
            update project2;
            
            List<IPM_Project__c> projectList = new List<IPM_Project__c>();
            Map<Id,IPM_Project__c> oldIpmprojectstest = new Map<Id,IPM_Project__c>();
            
            projectList.add(projects);
            projectList.add(project2);
            
            oldIpmprojectstest.put(projects.Id,project1);
            oldIpmprojectstest.put(project2.Id,project2);
            
            IPM_UpdateChildIpmProjects.updChildIPMProjects(projectList,oldIpmprojectstest);
        test.stopTest();
    }
}