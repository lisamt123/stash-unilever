/**
* IPM_List_Milestones_Test : This Test class for IPM_List_Milestones  apex class
* @author 
*
*/
@isTest
public class IPM_List_Milestones_Test
{    
    Static testMethod void listMilestone()
    {
        Test.startTest();
        
        Profile p=[Select Id from Profile where Name='Standard User'];       
        
        //Insert User 
        User u= new User(Alias = 'qtestim', Email='qstandarduserim@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='qTest Userim', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='qtestuserim@test362.com');
        //insert u;  
        
        //Insert User 
        User u1= new User(Alias = 'testiu1m', Email='standarduserium@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Userim', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuserim1@test362.com');
       // insert u1;      
        
        //Insert Company Card
        /*IPM_Company_Card__c compCard=new IPM_Company_Card__c();
        compCard.Name='Test Company Cardm';
        insert compCard;*/
        
        //Insert User Profile
       /* IPM_User_Profile__c up=new IPM_User_Profile__c();
        up.IPM_User__c=u.Id;
        insert up;*/
        
        //Insert User Profile
       /* IPM_User_Profile__c up1=new IPM_User_Profile__c();
        up1.IPM_User__c=u1.Id;
        //up1.IPM_Company_Card__c=compCard.Id;
        insert up1;*/
        
       // System.runAs(u)
        //{            
            //Insert Project
            IPM_Project__c proj=new IPM_Project__c();
            proj.IPM_Project_Name__c='Test Bossm';
            proj.IPM_Phase__c='Ideas';
            insert proj;
            System.Assert(proj.Id != null, 'The project record not inserted');
            
            PageReference pg = Page.ipmProjectSetup;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put('Pid', proj.id);
            IPM_List_Milestones  mileList=new IPM_List_Milestones();
            mileList.isCompleteMilestones='f';
            mileList.toggleDueDate();
            mileList.toggleSortMilestones();
            mileList.toggleSortPhases();
            mileList.toggleSortCompletion();
            mileList.toggleSortCompletedOn();
            mileList.filteredphaseM();
            mileList.filterCompleteMilestones();
            
            IPM_Milestone__c ipmMilestones = new IPM_Milestone__c(Name = 'Test Milestone', IPM_Project__c=proj.Id);
            insert ipmMilestones;
       
            IPM_Milestones_Delete constr = new IPM_Milestones_Delete(mileList);
            constr.milestoneId = ipmMilestones.Id;
            constr.deleteMilestone();
       // }
        Test.stopTest();
    }
}