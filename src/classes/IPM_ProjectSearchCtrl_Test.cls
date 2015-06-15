/**
* IPM_ProjectSearchCtrl_Test : This Test class for IPM_ProjectSearchCtrl apex class
* @author 
*
*/
@isTest
public class IPM_ProjectSearchCtrl_Test
{    
    Static testMethod void projectSearch()
    {
        Test.startTest();
        
        Profile p=[Select Id from Profile where Name='System Administrator'];       
        
        //Insert User 
        User u= new User(Alias = 'te471ps', Email='standarduse454s@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test 454Userps', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuserps@test454362.com');
        //insert u;       
        
        System.runAs(u)
        { 
            //Insert Project
            IPM_Project__c proj=new IPM_Project__c();
            proj.IPM_Project_Name__c='Test ProjectPS';
            proj.IPM_Phase__c='Ideas';
            insert proj;
            IPM_ProjectSearchCtrl psCtrl=new IPM_ProjectSearchCtrl();
            psCtrl.tldFrom ='01-Feb-2014';
            psCtrl.tldFrom ='23-Feb-2015';
            psCtrl.searchTxt='Test';
            psCtrl.mProjects='true';
            psCtrl.selectedPhase='Ideas';
            psCtrl.loadProjects();
            psCtrl.toggleSortProjects();
            psCtrl.toggleSortPhases();
            psCtrl.toggleSortPLs();
            psCtrl.toggleSortGKs();
            psCtrl.toggleSortITOs();
            psCtrl.toggleSortTLDs();
            psCtrl.first();
            psCtrl.last();
            psCtrl.previous();
            psCtrl.next();
            psCtrl.getPageNumber();
            psCtrl.getTotalPages();
            System.Assert(proj.Id != null, 'The project record not inserted');
        }
        Test.stopTest();
    }
}