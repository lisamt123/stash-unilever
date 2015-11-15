@istest(seealldata = true)
public class IPM_Update_MilestonesTest
{
     Public static testmethod void testmilestones()
     {
        IPM_Project__c projects=new IPM_Project__c();
        projects.Name='teest5555';
        projects.IPM_Project_Name__c='test43434445';
        projects.IPM_PM_Approach__c='Internal';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        insert projects;
                
        IPM_Milestone__c m = new IPM_Milestone__c();
        m.name = 'test';
        m.IPM_Type_of_Milestone__c = 'Standard';
        m.IPM_Project__c = projects.id;
        m.IPM_Type_of_gate__c = 'Charter';
        insert m;
        
        IPM_Project_Document__c ipd = new IPM_Project_Document__c();
        ipd.name = 'Test';
        ipd.IPM_Project__c =  projects.id;
        ipd.IPM_Approval_Date__c = system.today();
        ipd.IPM_Document_Status__c = 'Approved';
        ipd.IPM_GateDocuments__c = 'Charter';
        insert ipd;
        
        IPM_Project_Document__c ipd1 = new IPM_Project_Document__c();
        ipd1.name = 'Test';
        ipd1.IPM_Project__c =  projects.id;
        ipd1.IPM_Proposed_Date__c = system.today();
        ipd1.IPM_Document_Status__c = 'Proposed';
        ipd1.IPM_GateDocuments__c = 'Charter';
        insert ipd1;
        System.assert(m.Id != NULL);

     }
}